import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

// UserController - Gère la logique métier des utilisateurs
// Hérite de GetxController pour la gestion d'état réactive
class UserController extends GetxController {
  // RxList pour liste réactive d'utilisateurs
  // Obs permet à GetX d'écouter les changements automatiquement
  final RxList<User> users = <User>[].obs;

  // Rx pour le chargement (état)
  final RxBool isLoading = false.obs;

  // Rx pour les messages d'erreur
  final RxString errorMessage = ''.obs;

  final ApiService _apiService = ApiService();

  // Méthode pour charger tous les utilisateurs
  Future<void> fetchUsers() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Appel API
      final response = await _apiService.get<List<dynamic>>(
        'users',
        fromJson: (json) =>
            (json as List).map((userJson) => User.fromJson(userJson)).toList(),
      );

      if (response.success && response.data != null) {
        // Mise à jour de la liste réactive
        users.assignAll((response.data as List<dynamic>).cast<User>());
      } else {
        errorMessage.value = response.message;
        Get.snackbar('Erreur', response.message);
      }
    } catch (e) {
      errorMessage.value = 'Exception: $e';
      Get.snackbar('Erreur', 'Une exception est survenue');
    } finally {
      isLoading.value = false;
    }
  }

  // Méthode pour créer un nouvel utilisateur
  Future<bool> createUser(String name, String email) async {
    isLoading.value = true;

    try {
      final response = await _apiService.post<User>('users', {
        'name': name,
        'email': email,
      }, fromJson: User.fromJson);

      if (response.success && response.data != null) {
        // Ajout du nouvel utilisateur à la liste
        users.add(response.data!);
        Get.snackbar('Succès', 'Utilisateur créé avec succès');
        return true;
      } else {
        errorMessage.value = response.message;
        Get.snackbar('Erreur', response.message);
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Exception: $e';
      Get.snackbar('Erreur', 'Une exception est survenue');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Méthode pour mettre à jour un utilisateur
  Future<bool> updateUser(User user) async {
    if (user.id == null) return false;

    isLoading.value = true;

    try {
      final response = await _apiService.put<User>(
        'users/${user.id!.value}',
        user.toJson(),
        fromJson: User.fromJson,
      );

      if (response.success && response.data != null) {
        // Trouver l'index et mettre à jour
        final index = users.indexWhere((u) => u.id?.value == user.id?.value);
        if (index != -1) {
          users[index] = response.data!;
        }
        Get.snackbar('Succès', 'Utilisateur mis à jour');
        return true;
      } else {
        errorMessage.value = response.message;
        Get.snackbar('Erreur', response.message);
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Exception: $e';
      Get.snackbar('Erreur', 'Une exception est survenue');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Méthode pour supprimer un utilisateur
  Future<bool> deleteUser(int userId) async {
    isLoading.value = true;

    try {
      final response = await _apiService.delete<Map<String, dynamic>>(
        'users/$userId',
      );

      if (response.success) {
        // Retirer de la liste
        users.removeWhere((user) => user.id?.value == userId);
        Get.snackbar('Succès', 'Utilisateur supprimé');
        return true;
      } else {
        errorMessage.value = response.message;
        Get.snackbar('Erreur', response.message);
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Exception: $e';
      Get.snackbar('Erreur', 'Une exception est survenue');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
