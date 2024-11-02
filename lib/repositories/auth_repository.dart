import 'package:app_manager/models/auth/login_dto.dart';
import 'package:app_manager/models/auth/register_dto.dart';
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

  Future<void> logout() async {
    await _authService.logout();
  }

  Future<bool> register(String username, String password) async {
    try {
      final registerData = RegisterDto(email: username, password: password);
      var response = await _authService.register(registerData);
      if (response) {
        try {
          await sendOtp(username);
          return true;
        } catch (error) {
          throw Exception('Failed to send OTP: $error');
        }
      } else {
        return false;
      }
    } catch (error) {
      throw Exception('Failed to register: $error');
    }
  }

  Future<bool> verifyOtp(String email, String otp) async {
    try {
      return await _authService.verifyOtp(email, otp);
    } catch (error) {
      throw Exception('Failed to verify OTP: $error');
    }
  }

  Future<void> sendOtp(String email) async {
    try {
      await _authService.sendOtp(email);
    } catch (error) {
      throw Exception('Failed to send OTP: $error');
    }
  }

  Future<bool> resetPassword(String email, String otp, String password) async {
    try {
      return await _authService.resetPassword(email, otp, password);
    } catch (error) {
      throw Exception('Failed to reset password: $error');
    }
  }
}
