import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/post_controller.dart';

// Vue pour afficher la liste des posts
class PostListView extends StatelessWidget {
  final PostController postController = Get.find<PostController>();

  PostListView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      postController.fetchPosts();
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Liste des Posts')),
      body: Obx(() {
        if (postController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (postController.posts.isEmpty) {
          return const Center(child: Text('Aucun post trouvé'));
        }

        return ListView.builder(
          itemCount: postController.posts.length,
          itemBuilder: (context, index) {
            final post = postController.posts[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title.value,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(post.content.value),
                    const SizedBox(height: 8),
                    Text(
                      'Utilisateur ID: ${post.userId.value}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
