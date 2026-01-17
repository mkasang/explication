// Ce modèle représente la réponse standard de l'API
// Il permet de standardiser la gestion des réponses API (succès/erreur)
class ApiResponse<T> {
  final bool success; // Indique si la requête a réussi
  final String message; // Message de l'API (succès ou erreur)
  final T? data; // Données retournées (générique pour s'adapter à tout type)
  final int? statusCode; // Code HTTP de la réponse

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.statusCode,
  });

  // Factory constructor pour créer une réponse à partir d'un JSON
  // Permet de convertir facilement les données JSON en objet Dart
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: fromJsonT != null && json['data'] != null
          ? fromJsonT(json['data'])
          : json['data'],
      statusCode: json['statusCode'],
    );
  }
}
