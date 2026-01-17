import 'package:get/get.dart';

// Modèle Post - Représente un article ou publication
class Post {
  RxInt? id; // Identifiant unique
  RxString title; // Titre du post
  RxString content; // Contenu du post
  RxInt userId; // ID de l'utilisateur qui a créé le post (clé étrangère)
  RxString? createdAt; // Date de création

  Post({
    this.id,
    required String title,
    required String content,
    required int userId,
    this.createdAt,
  }) : title = title.obs,
       content = content.obs,
       userId = userId.obs;

  // Conversion JSON → Objet Dart
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] != null ? RxInt(json['id']) : null,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      userId: json['user_id'] ?? 0,
      createdAt: json['created_at'],
    );
  }

  // Conversion Objet Dart → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id?.value,
      'title': title.value,
      'content': content.value,
      'user_id': userId.value,
      'created_at': createdAt,
    };
  }
}
