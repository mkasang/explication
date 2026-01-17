import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_response.dart';

// Service pour gérer toutes les communications HTTP avec l'API
class ApiService {
  static const String baseUrl = 'https://masomo.jobyrdc.com/api';
  // Headers communs pour toutes les requêtes
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Méthode générique pour les requêtes GET
  // <T> permet de spécifier le type de données attendu
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    T Function(Map<String, dynamic>)? fromJson,
    Map<String, String>? queryParams,
  }) async {
    try {
      final uri = Uri.parse(
        '$baseUrl/$endpoint',
      ).replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: headers);

      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      return ApiResponse<T>.fromJson(jsonResponse, fromJson);
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: 'Erreur de connexion: $e',
        statusCode: 500,
      );
    }
  }

  // Méthode générique pour les requêtes POST
  Future<ApiResponse<T>> post<T>(
    String endpoint,
    Map<String, dynamic> data, {
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/$endpoint');

      final response = await http.post(
        uri,
        headers: headers,
        body: json.encode(data),
      );

      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      return ApiResponse<T>.fromJson({
        ...jsonResponse,
        'statusCode': response.statusCode,
      }, fromJson);
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: 'Erreur: $e',
        statusCode: 500,
      );
    }
  }

  // Méthode pour les requêtes PUT (mise à jour)
  Future<ApiResponse<T>> put<T>(
    String endpoint,
    Map<String, dynamic> data, {
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/$endpoint');

      final response = await http.put(
        uri,
        headers: headers,
        body: json.encode(data),
      );

      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      return ApiResponse<T>.fromJson({
        ...jsonResponse,
        'statusCode': response.statusCode,
      }, fromJson);
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: 'Erreur: $e',
        statusCode: 500,
      );
    }
  }

  // Méthode pour les requêtes DELETE
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/$endpoint');

      final response = await http.delete(uri, headers: headers);

      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      return ApiResponse<T>.fromJson({
        ...jsonResponse,
        'statusCode': response.statusCode,
      }, fromJson);
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: 'Erreur: $e',
        statusCode: 500,
      );
    }
  }
}
