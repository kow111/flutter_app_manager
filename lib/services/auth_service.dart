import 'dart:convert';
import 'package:app_manager/models/auth/login_dto.dart';
import 'package:app_manager/models/auth/register_dto.dart';

import 'api_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<bool> login(LoginDto loginDto) async {
    var response = await _apiClient.postPublic(
      '/auth/login',
      loginDto.toJson(),
    );
    try {
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String token = responseData['DT']['token'];
        await _secureStorage.write(key: 'token', value: token);
        return true;
      } else {
        return false;
      }
    } catch (error) {
      throw Exception('Failed to login: $error');
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'token');
  }

  Future<bool> register(RegisterDto registerDto) async {
    var response = await _apiClient.postPublic(
      '/auth/signup',
      registerDto.toJson(),
    );
    try {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      throw Exception('Failed to register: $error');
    }
  }

  Future<bool> verifyOtp(String email, String otp) async {
    var response = await _apiClient.postPrivate(
      '/auth/verified-user',
      {'email': email, 'otp': otp},
    );
    try {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      throw Exception('Failed to verify OTP: $error');
    }
  }

  Future<void> sendOtp(String email) async {
    var response = await _apiClient.postPublic(
      '/auth/send-otp',
      {'email': email},
    );
    try {
      if (response.statusCode != 200) {
        throw Exception('Failed to send OTP');
      }
    } catch (error) {
      throw Exception('Failed to send OTP: $error');
    }
  }

  Future<bool> resetPassword(String email, String otp, String password) async {
    var response = await _apiClient.postPublic('/auth/reset-password', {
      'email': email,
      'otp': otp,
      'newPassword': password,
    });
    try {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      throw Exception('Failed to reset password: $error');
    }
  }
}
