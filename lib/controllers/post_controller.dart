import 'package:get/get.dart';
import '../models/post_model.dart';
import '../services/api_service.dart';

// PostController - Gère la logique métier des posts
class PostController extends GetxController {
  final RxList<Post> posts = <Post>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final ApiService _apiService = ApiService();

  // Charger tous les posts
  Future<void> fetchPosts() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _apiService.get<List<dynamic>>(
        'posts',
        fromJson: (json) =>
            (json as List).map((postJson) => Post.fromJson(postJson)).toList(),
      );

      if (response.success && response.data != null) {
        posts.assignAll((response.data as List<dynamic>).cast<Post>());
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

  // Charger les posts d'un utilisateur spécifique
  Future<void> fetchUserPosts(int userId) async {
    isLoading.value = true;

    try {
      final response = await _apiService.get<List<dynamic>>(
        'posts',
        queryParams: {'user_id': userId.toString()},
        fromJson: (json) =>
            (json as List).map((postJson) => Post.fromJson(postJson)).toList(),
      );

      if (response.success && response.data != null) {
        posts.assignAll((response.data as List<dynamic>).cast<Post>());
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = 'Exception: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Créer un nouveau post
  Future<bool> createPost(String title, String content, int userId) async {
    isLoading.value = true;

    try {
      final response = await _apiService.post<Post>('posts', {
        'title': title,
        'content': content,
        'user_id': userId,
      }, fromJson: Post.fromJson);

      if (response.success && response.data != null) {
        posts.add(response.data!);
        Get.snackbar('Succès', 'Post créé avec succès');
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
