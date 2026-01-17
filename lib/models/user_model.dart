import 'package:get/get.dart';

// Modèle User - Représente un utilisateur dans l'application
// GetX Observable (avec .obs) permet une réactivité automatique
class User {
  RxInt? id; // Identifiant unique - RxInt pour la réactivité
  RxString name; // Nom de l'utilisateur
  RxString email; // Email de l'utilisateur
  RxString? createdAt; // Date de création - Peut être null

  User({this.id, required String name, required String email, this.createdAt})
    : name = name.obs,
      email = email.obs;

  // Factory constructor pour créer un User à partir d'un JSON
  // Permet de convertir les données API (JSON) en objet Dart
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] != null ? RxInt(json['id']) : null,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      createdAt: json['created_at'],
    );
  }

  // Convertir l'objet User en Map pour l'envoi à l'API
  Map<String, dynamic> toJson() {
    return {
      'id': id?.value,
      'name': name.value,
      'email': email.value,
      'created_at': createdAt,
    };
  }

  // Méthode pour créer une copie de l'objet avec des valeurs optionnelles modifiées
  // Utile pour les mises à jour partielles
  User copyWith({int? id, String? name, String? email, String? createdAt}) {
    return User(
      id: id != null ? RxInt(id) : this.id,
      name: name ?? this.name.value,
      email: email ?? this.email.value,
      createdAt: createdAt != null ? RxString(createdAt) : this.createdAt,
    );
  }
}
