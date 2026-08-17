import 'dart:convert';
import 'package:petrimonium/core/network/api_client.dart';
import 'package:petrimonium/core/network/api_error_parser.dart';
import 'package:petrimonium/core/constants/api_constants.dart';
import 'package:petrimonium/features/auth/data/models/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource({required this.apiClient});

  Future<UserModel> login(String email, String password) async {
    final response = await apiClient.post(
      ApiConstants.loginEndpoint,
      {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw Exception(extractErrorDetail(response, fallback: 'Failed to login. Status Code: ${response.statusCode}'));
    }
  }

  Future<UserModel> register(String name, String email, String password) async {
    final response = await apiClient.post(
      ApiConstants.registerEndpoint,
      {
        'username': name,
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw Exception(extractErrorDetail(response, fallback: 'Failed to register. Status Code: ${response.statusCode}'));
    }
  }

  /// Backend always answers 200 here (even for an unregistered email) to
  /// avoid user enumeration, so the only failure mode worth surfacing is a
  /// transport-level error, which `apiClient.post` already throws for.
  Future<void> requestPasswordReset(String email) async {
    final response = await apiClient.post(
      ApiConstants.forgotPasswordEndpoint,
      {'email': email},
    );

    if (response.statusCode != 200) {
      throw Exception(
        extractErrorDetail(response, fallback: 'Failed to request password reset. Status Code: ${response.statusCode}'),
      );
    }
  }

  Future<void> resetPassword(String token, String newPassword) async {
    final response = await apiClient.post(
      ApiConstants.resetPasswordEndpoint,
      {'token': token, 'newPassword': newPassword},
    );

    if (response.statusCode != 200) {
      throw Exception(
        extractErrorDetail(response, fallback: 'Failed to reset password. Status Code: ${response.statusCode}'),
      );
    }
  }
}
