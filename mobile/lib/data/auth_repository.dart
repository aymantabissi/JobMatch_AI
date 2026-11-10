
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/dio_client.dart';
import '../core/storage.dart';
import '../models/app_user.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    dio: ref.read(dioProvider),
    storage: ref.read(tokenStorageProvider),
  );
});

class AuthRepository {
  final Dio dio;
  final TokenStorage storage;

  AuthRepository({
    required this.dio,
    required this.storage,
  });

  // Extract data from API response
  Map<String, dynamic> _responseData(dynamic response) {
    if (response is! Map) {
      throw Exception('Réponse serveur invalide.');
    }

    final data = response['data'];

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    return Map<String, dynamic>.from(response);
  }

  // Save token and return user
  Future<AppUser> _handleAuthResponse(dynamic response) async {
    final data = _responseData(response);

    final token = data['token'] ?? data['accessToken'];

    if (token == null || token.toString().isEmpty) {
      throw Exception('Token JWT manquant dans la réponse.');
    }

    final userData = data['user'];

    if (userData is! Map) {
      throw Exception('Informations utilisateur manquantes.');
    }

    final user = AppUser.fromJson(
      Map<String, dynamic>.from(userData),
    );

    await storage.save(token.toString());

    return user;
  }

  // LOGIN
  Future<AppUser> login(
    String email,
    String password,
  ) async {
    final response = await dio.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    return _handleAuthResponse(response.data);
  }

  // REGISTER
  Future<AppUser> register({
    required String fullName,
    required String email,
    required String password,
    required String role,
    String? companyName,
  }) async {
    final response = await dio.post(
      '/auth/register',
      data: {
        'fullName': fullName,
        'email': email,
        'password': password,
        'role': role,
        if (role == 'recruiter')
          'companyName': companyName,
      },
    );

    return _handleAuthResponse(response.data);
  }

  // RESTORE SESSION
  Future<AppUser?> restoreSession() async {
    final token = await storage.read();

    if (token == null || token.isEmpty) {
      return null;
    }

    try {
      final response = await dio.get('/auth/me');

      final data = _responseData(response.data);

      final userData = data['user'] ?? data;

      if (userData is! Map) {
        throw Exception('Utilisateur invalide.');
      }

      return AppUser.fromJson(
        Map<String, dynamic>.from(userData),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 ||
          e.response?.statusCode == 403) {
        await storage.clear();
        return null;
      }

      rethrow;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await storage.clear();
  }
}
