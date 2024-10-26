import 'package:app_manager/models/auth/login_dto.dart';
import 'package:app_manager/services/auth_service.dart';

class AuthRepository {
  final AuthService _authService = AuthService();
  Future<bool> login(String username, String password) async {
    try {
      final loginData = LoginDto(email: username, password: password);
      return await _authService.login(loginData);
    } catch (error) {
      throw Exception('Failed to login: $error');
    }
  }
}
