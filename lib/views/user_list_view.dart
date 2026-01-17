import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mvc_getx/models/user_model.dart';
import '../controllers/user_controller.dart';
import 'add_user_view.dart';

// Vue pour afficher et gérer la liste des utilisateurs
class UserListView extends StatelessWidget {
  // Obtention du contrôleur avec Get.find()
  // GetX gère l'instance unique (singleton) automatiquement
  final UserController userController = Get.find<UserController>();

  UserListView({super.key});

  @override
  Widget build(BuildContext context) {
    // Premier chargement des données
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userController.fetchUsers();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Utilisateurs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: userController.fetchUsers,
          ),
        ],
      ),
      body: Obx(() {
        // Obx() réagit automatiquement aux changements dans userController
        if (userController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (userController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Erreur: ${userController.errorMessage.value}'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: userController.fetchUsers,
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        }

        if (userController.users.isEmpty) {
          return const Center(child: Text('Aucun utilisateur trouvé'));
        }

        // Liste des utilisateurs
        return ListView.builder(
          itemCount: userController.users.length,
          itemBuilder: (context, index) {
            final user = userController.users[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(user.name.value.substring(0, 1).toUpperCase()),
                ),
                title: Text(user.name.value),
                subtitle: Text(user.email.value),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showEditUserDialog(user),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        size: 20,
                        color: Colors.red,
                      ),
                      onPressed: () => _deleteUser(user.id?.value),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigation vers la vue d'ajout
          Get.to(() => AddUserView());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Fonction pour afficher le dialogue de modification
  void _showEditUserDialog(User user) {
    final nameController = TextEditingController(text: user.name.value);
    final emailController = TextEditingController(text: user.email.value);

    Get.defaultDialog(
      title: 'Modifier l\'utilisateur',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nom'),
          ),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
      confirm: ElevatedButton(
        onPressed: () async {
          final updatedUser = user.copyWith(
            name: nameController.text,
            email: emailController.text,
          );
          await userController.updateUser(updatedUser);
          Get.back();
        },
        child: const Text('Enregistrer'),
      ),
      cancel: TextButton(onPressed: Get.back, child: const Text('Annuler')),
    );
  }

  // Fonction pour supprimer un utilisateur
  void _deleteUser(int? userId) {
    if (userId == null) return;

    Get.defaultDialog(
      title: 'Confirmation',
      middleText: 'Voulez-vous vraiment supprimer cet utilisateur ?',
      confirm: ElevatedButton(
        onPressed: () async {
          await userController.deleteUser(userId);
          Get.back();
        },
        child: const Text('Oui'),
      ),
      cancel: TextButton(onPressed: Get.back, child: const Text('Non')),
    );
  }
}
