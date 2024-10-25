import 'package:app_manager/models/auth/login_dto.dart';
import 'package:app_manager/services/auth_service.dart';

class AuthRepository {
  final AuthService _authService = AuthService();
  Future<bool> login(String username, String password) async {
    final loginData = LoginDto(email: username, password: password);
    return await _authService.login(loginData);
  }
}
