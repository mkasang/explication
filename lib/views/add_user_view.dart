import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';

// Vue pour ajouter un nouvel utilisateur
class AddUserView extends StatelessWidget {
  AddUserView({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un Utilisateur')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nom',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 32),
            Obx(() {
              if (userController.isLoading.value) {
                return const CircularProgressIndicator();
              }
              return ElevatedButton(
                onPressed: () async {
                  if (nameController.text.isEmpty ||
                      emailController.text.isEmpty) {
                    Get.snackbar('Erreur', 'Veuillez remplir tous les champs');
                    return;
                  }

                  final success = await userController.createUser(
                    nameController.text,
                    emailController.text,
                  );

                  if (success) {
                    Get.back(); // Retour à la liste
                  }
                },
                child: const Text('Créer l\'utilisateur'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
