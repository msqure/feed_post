import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../domain/model/post_model.dart';


class FeedService {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File imageFile) async {
    try {
      if (!await imageFile.exists()) {
        throw Exception('Selected file does not exist');
      }

      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = _storage.ref().child('posts/$fileName.jpg');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("🔥 Upload failed: $e");
      rethrow;
    }
  }

  Future<void> toggleLike(String postId, String userId) async {
    final postRef = _firestore.collection('posts').doc(postId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(postRef);
      if (!snapshot.exists) return;

      final likedBy = List<String>.from(snapshot['likedBy'] ?? []);
      final likesCount = snapshot['likesCount'] ?? 0;

      if (likedBy.contains(userId)) {
        likedBy.remove(userId);
        transaction.update(postRef, {
          'likedBy': likedBy,
          'likesCount': likesCount - 1,
        });
      } else
      {
        likedBy.add(userId);
        transaction.update(postRef, {
          'likedBy': likedBy,
          'likesCount': likesCount + 1,
        });
      }
    });
  }




  Future<void> createPost(String caption, File imageFile, String userId) async {
    try {
      final imageUrl = await uploadImage(imageFile);

      await _firestore.collection('posts')..add({
        'userId': userId,
        'caption': caption,
        'imageUrl': imageUrl,
        'createdAt': DateTime.now().millisecond,
      });
    } catch (e) {
      print("Error creating post: $e");
      rethrow;
    }
  }

  Future<void> editPost(String postId, {String? caption, File? imageFile}) async {
    try {
      final postRef = _firestore.collection('posts').doc(postId);
      final updateData = <String, dynamic>{};

      if (caption != null) updateData['caption'] = caption;
      if (imageFile != null) {
        final newImageUrl = await uploadImage(imageFile);
        updateData['imageUrl'] = newImageUrl;
      }

      await postRef.update(updateData);
    } catch (e) {
      print("Error editing post: $e");
      rethrow;
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print("Error deleting post: $e");
      rethrow;
    }
  }
  Stream<List<PostModel>> getPosts() {
    try {
      return _firestore
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((QuerySnapshot<Map<String, dynamic>> snap) {
        print('Fetched ${snap.docs.length} documents from Firestore.');

        return snap.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
          try {
            final data = doc.data();
            return PostModel.fromMap(doc.id, data);
          } catch (e) {
            ("Error parsing document with ID ${doc.id}: $e");
            // You might want to return a default PostModel, or skip this document
            // For now, rethrow to indicate a problem with this specific doc
            rethrow;
          }
        }).toList();
      });
    } catch (e) {
      print("Error fetching posts: $e");
      rethrow; // Rethrow the error to be handled by the caller
    }
  }
}

