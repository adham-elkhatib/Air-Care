import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Data/Model/User/user.model.dart' as app_user;
import '../../../Data/Model/posts/comment.dart';
import '../../../Data/Model/posts/posts.dart';
import '../../../Data/Repositories/post_repo.dart';
import '../../../Data/Repositories/user.repo.dart';
import '../../../core/Services/Auth/auth.service.dart';
import '../../../core/Services/Auth/src/Providers/firebase/firebase_auth_provider.dart';

class PostWidget extends StatefulWidget {
  final Post post;

  const PostWidget({super.key, required this.post});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  late int likesCount;
  bool isLiked = false;
  bool _isCommenting = false;
  final TextEditingController _commentController = TextEditingController();

  final String? userId = AuthService(
    authProvider: FirebaseAuthProvider(firebaseAuth: FirebaseAuth.instance),
  ).getCurrentUserId();

  @override
  void initState() {
    super.initState();
    likesCount = widget.post.likes.length;
    isLiked = widget.post.likes[userId] ?? false;
  }

  Future<void> _toggleLike() async {
    setState(() {
      isLiked = !isLiked;
      likesCount += isLiked ? 1 : -1;
    });
    widget.post.likes[userId!] = isLiked;
    await PostsRepo().updateSingle(widget.post.id, widget.post);
  }

  Future<void> _submitComment() async {
    if (_commentController.text.trim().isEmpty) return;

    app_user.UserModel? appUser = await UserRepo().readSingle(userId!);

    final newComment = Comment(
      publisherName: appUser!.name,
      commentText: _commentController.text.trim(),
      commentedDate: DateTime.now(),
    );

    widget.post.comments.insert(0, newComment);
    await PostsRepo().updateSingle(widget.post.id, widget.post);

    _commentController.clear();
    setState(() => _isCommenting = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(widget.post.publisherImageUrl),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.post.publisherName,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// Post Text
          if (widget.post.text != null)
            Text(
              widget.post.text!,
              style: textTheme.bodyLarge?.copyWith(color: Colors.white70),
            ),

          /// Post Image
          if (widget.post.imageUrl != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(widget.post.imageUrl!, fit: BoxFit.cover),
              ),
            ),

          /// Actions Row
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: isLiked ? Colors.redAccent : Colors.white70,
                ),
                onPressed: _toggleLike,
                tooltip: "Like",
              ),
              Text(
                '$likesCount',
                style: textTheme.bodySmall?.copyWith(color: Colors.white60),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.comment, color: Colors.white70),
                onPressed: () {
                  setState(() {
                    _isCommenting = !_isCommenting;
                  });
                },
                tooltip: "Comment",
              ),
            ],
          ),

          /// Comment Input
          if (_isCommenting)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Write a comment...",
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _submitComment,
                    tooltip: "Submit comment",
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
