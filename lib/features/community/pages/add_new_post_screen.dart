import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Data/Model/posts/posts.dart';
import '../../../Data/Repositories/post_repo.dart';
import '../../../Data/Repositories/user.repo.dart';
import '../../../core/Services/Auth/auth.service.dart';
import '../../../core/Services/Auth/src/Providers/firebase/firebase_auth_provider.dart';
import '../../../core/Services/Firebase Storage/firebase_storage.service.dart';
import '../../../core/Services/Firebase Storage/src/models/storage_file.model.dart';
import '../../../core/Services/Id Generating/id_generating.service.dart';
import '../../../core/utils/SnackBar/snackbar.helper.dart';
import '../../../core/widgets/primary_button.dart';

class AddNewPostScreen extends StatefulWidget {
  const AddNewPostScreen({super.key});

  @override
  State<AddNewPostScreen> createState() => _AddNewPostScreenState();
}

class _AddNewPostScreenState extends State<AddNewPostScreen> {
  final TextEditingController _textController = TextEditingController();
  Uint8List? _selectedImageBytes;
  File? _selectedImage;
  bool isUploading = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 30,
    );
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
        });
      } else {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    }
  }

  Future<void> _submitPost() async {
    if (_textController.text.isEmpty &&
        _selectedImage == null &&
        _selectedImageBytes == null) {
      SnackbarHelper.showError(
        context,
        title: "Please enter text or select an image",
      );
      return;
    }

    setState(() => isUploading = true);

    final id = IdGeneratingService.generate();
    String? postImageUrl;
    final userId = AuthService(
      authProvider: FirebaseAuthProvider(firebaseAuth: FirebaseAuth.instance),
    ).getCurrentUserId();

    final user = await UserRepo().readSingle(userId!);

    final imageData = kIsWeb
        ? _selectedImageBytes
        : _selectedImage != null
        ? await _selectedImage!.readAsBytes()
        : null;

    if (imageData != null) {
      final uploadRef = await FirebaseStorageService.uploadSingle(
        '/posts/${user!.id}',
        StorageFile(data: imageData, fileName: id, fileExtension: "jpeg"),
      );

      postImageUrl = await uploadRef?.ref.getDownloadURL();
    }

    final newPost = Post(
      id: id,
      publisherName: user!.name,
      publisherImageUrl: "https://www.w3schools.com/howto/img_avatar.png",
      text: _textController.text.trim().isEmpty
          ? null
          : _textController.text.trim(),
      imageUrl: postImageUrl,
      publishedDate: DateTime.now(),
      comments: [],
      likes: {},
    );

    await PostsRepo().createSingle(newPost, itemId: id);

    SnackbarHelper.showTemplated(context, title: "Post added successfully!");
    Navigator.pop(context, newPost);
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        // يخلّي زرار الـ Drawer يظهر
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 120,
        title: Column(
          children: [
            SizedBox(
              height: 60,
              child: Image.asset(
                "assets/images/Logo 01 black background.png",
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            const Text("Create Post"),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F1114), Color(0xFF1A1E23), Color(0xFF2C2F3A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: isUploading
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _textController,
                          maxLines: 4,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "What's on your mind?",
                            hintStyle: const TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),
                        const SizedBox(height: 16),

                        /// Image Preview
                        if (kIsWeb && _selectedImageBytes != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(
                              _selectedImageBytes!,
                              width: double.infinity,
                              height: 240,
                              fit: BoxFit.cover,
                            ),
                          )
                        else if (_selectedImage != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              _selectedImage!,
                              width: double.infinity,
                              height: 240,
                              fit: BoxFit.cover,
                            ),
                          ),

                        const SizedBox(height: 12),

                        /// Add Image
                        TextButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.image, color: Colors.white70),
                          label: const Text(
                            "Add Image",
                            style: TextStyle(color: Colors.white70),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 24),

                        /// Post Button
                        SizedBox(
                          width: double.infinity,
                          child: PrimaryButton(
                            onPressed: _submitPost,
                            title: "Post",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
