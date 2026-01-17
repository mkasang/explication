import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'user_list_view.dart';
import 'post_list_view.dart';

// Vue d'accueil - Interface principale
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter MVC avec GetX + API'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bouton pour accéder à la liste des utilisateurs
            ElevatedButton(
              onPressed: () {
                // Navigation avec GetX (similaire à Navigator.push)
                Get.to(() => UserListView());
              },
              child: const Text('Gestion des Utilisateurs'),
            ),
            const SizedBox(height: 20),
            // Bouton pour accéder à la liste des posts
            ElevatedButton(
              onPressed: () {
                Get.to(() => PostListView());
              },
              child: const Text('Voir tous les Posts'),
            ),
            const SizedBox(height: 40),
            const Text(
              'API: https://masomo.jobyrdc.com',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
