import 'package:flutter/material.dart';

import '../../../Data/Repositories/post_repo.dart';
import '../../../core/widgets/section_placeholder.dart';
import '../widgets/post_widget.dart';
import 'add_new_post_screen.dart';
import 'post_details_screen.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F1114), Color(0xFF1A1E23), Color(0xFF2C2F3A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24,
              ),
              child: FutureBuilder(
                future: PostsRepo().readAll(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final posts = snapshot.data!;

                    return ListView.separated(
                      itemCount: posts.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PostDetailsScreen(post: posts[index]!),
                            ),
                          );
                        },
                        child: PostWidget(post: posts[index]!),
                      ),
                    );
                  } else {
                    return const SectionPlaceholder(
                      title: "There are no posts yet",
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddNewPostScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("New Post"),
      ),
    );
  }
}
