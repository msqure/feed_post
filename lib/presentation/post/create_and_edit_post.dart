import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../blocs/feeds/feed_bloc.dart';
import '../../blocs/feeds/feed_event.dart';
import '../../model/post_model.dart';


class CreateEditPostScreen extends StatefulWidget {
  final bool isEdit;
  final PostModel? existingPost;

  const CreateEditPostScreen({super.key, this.isEdit = false, this.existingPost});

  @override
  State<CreateEditPostScreen> createState() => _CreateEditPostScreenState();
}

class _CreateEditPostScreenState extends State<CreateEditPostScreen> {
  final _captionController = TextEditingController();
  File? _selectedImage;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.existingPost != null) {
      _captionController.text = widget.existingPost!.caption;
    }
  }

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  void _submit() {
    final caption = _captionController.text.trim();
    if (caption.isEmpty || (!widget.isEdit && _selectedImage == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Caption and image are required.')),
      );
      return;
    }

    final bloc = context.read<PostBloc>();

    if (widget.isEdit && widget.existingPost != null) {
      bloc.add(EditPost(
        widget.existingPost!.id,
        caption: caption.isNotEmpty ? caption : null,
        imageFile: _selectedImage,
      ));
    } else {
      const userId = 'qocJm67z1tcbt08W3ZEgiASR7st1';
      bloc.add(CreatePost(caption, _selectedImage!, userId));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.isEdit;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Post' : 'Create Post')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: _selectedImage != null
                  ? Image.file(_selectedImage!, height: 200, fit: BoxFit.cover)
                  : widget.isEdit && widget.existingPost != null
                  ? Image.network(widget.existingPost!.imageUrl, height: 200)
                  : Container(
                height: 200,
                color: Colors.grey[200],
                child: Icon(Icons.add_a_photo, size: 50),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _captionController,
              decoration: InputDecoration(labelText: 'Caption'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text(isEdit ? 'Update' : 'Create'),
            )
          ],
        ),
      ),
    );
  }
}
