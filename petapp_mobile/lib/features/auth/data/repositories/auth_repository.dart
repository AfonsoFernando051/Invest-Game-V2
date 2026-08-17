import 'package:shared_preferences/shared_preferences.dart';
import 'package:petrimonium/features/auth/data/datasources/auth_remote_datasource.dart';

class AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepository({required this.remoteDataSource});

  Future<void> login(String email, String password) async {
    final user = await remoteDataSource.login(email, password);
    await _saveToken(user.token);
    await _saveEmail(email);
  }

  Future<void> register(String name, String email, String password) async {
    final user = await remoteDataSource.register(name, email, password);
    await _saveToken(user.token);
    await _saveEmail(email);
  }

  /// Always succeeds server-side regardless of whether [email] belongs to an
  /// account (avoids leaking which emails are registered).
  Future<void> requestPasswordReset(String email) {
    return remoteDataSource.requestPasswordReset(email);
  }

  Future<void> resetPassword(String token, String newPassword) {
    return remoteDataSource.resetPassword(token, newPassword);
  }

  Future<void> logout() async {
    // The bearer token lives in secure storage (see ApiClient); only the
    // non-sensitive last-used email stays in SharedPreferences.
    await remoteDataSource.apiClient.clearToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_email');
  }

  Future<void> _saveToken(String? token) async {
    if (token != null && token.isNotEmpty) {
      await remoteDataSource.apiClient.saveToken(token);
    }
  }

  Future<void> _saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_email', email);
  }

  Future<String?> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_email');
  }

  Future<bool> isLoggedIn() async {
    final token = await remoteDataSource.apiClient.readToken();
    return token != null;
  }
}
