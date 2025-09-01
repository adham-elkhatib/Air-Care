import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Data/Model/posts/comment.dart';
import '../../../Data/Model/posts/posts.dart';
import '../../../Data/Repositories/post_repo.dart';
import '../../../Data/Repositories/user.repo.dart';
import '../../../core/Services/Auth/auth.service.dart';
import '../../../core/Services/Auth/src/Providers/firebase/firebase_auth_provider.dart';

class PostDetailsScreen extends StatefulWidget {
  final Post post;

  const PostDetailsScreen({super.key, required this.post});

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  int likesCount = 0;
  bool isLiked = false;
  bool _isCommenting = false;
  final TextEditingController _commentController = TextEditingController();
  String? userId = AuthService(
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
      widget.post.likes[userId!] = isLiked;
    });
    await PostsRepo().updateSingle(widget.post.id, widget.post);
  }

  Future<void> _submitComment() async {
    if (_commentController.text.trim().isEmpty) return;

    final appUser = await UserRepo().readSingle(userId!);
    final newComment = Comment(
      publisherName: appUser!.name,
      commentText: _commentController.text.trim(),
      commentedDate: DateTime.now(),
    );

    setState(() {
      widget.post.comments.insert(0, newComment);
      _commentController.clear();
      _isCommenting = false;
    });

    await PostsRepo().updateSingle(widget.post.id, widget.post);
  }

  @override
  Widget build(BuildContext context) {
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
            const Text("Post Details"),
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Post Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Publisher Info
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                widget.post.publisherImageUrl,
                              ),
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
                            style: textTheme.bodyLarge?.copyWith(
                              color: Colors.white70,
                            ),
                          ),

                        /// Post Image
                        if (widget.post.imageUrl != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                widget.post.imageUrl!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                        /// Like & Comment
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color: isLiked
                                    ? Colors.redAccent
                                    : Colors.white54,
                              ),
                              onPressed: _toggleLike,
                              tooltip: "Like",
                            ),
                            Text(
                              '$likesCount Likes',
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.white60,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(
                                Icons.comment,
                                color: Colors.white60,
                              ),
                              onPressed: () {
                                setState(() => _isCommenting = !_isCommenting);
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
                                      hintStyle: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.1),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 10,
                                          ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  ),
                                  onPressed: _submitComment,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  Text(
                    "Comments",
                    style: textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),

                  const SizedBox(height: 12),

                  /// Comments Section
                  if (widget.post.comments.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          "No comments yet",
                          style: textTheme.bodyLarge?.copyWith(
                            color: Colors.white60,
                          ),
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.post.comments.length,
                      separatorBuilder: (_, __) =>
                          Divider(color: Colors.white.withOpacity(0.1)),
                      itemBuilder: (context, index) {
                        final comment = widget.post.comments[index];
                        return Card(
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.white12,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            title: Text(
                              comment.publisherName,
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              comment.commentText,
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        );
                      },
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
