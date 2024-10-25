import 'dart:convert';
import 'package:app_manager/models/auth/login_dto.dart';

import 'api_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // API đăng nhập
  Future<bool> login(LoginDto loginDto) async {
    var response = await _apiClient.postPublic(
      '/auth/login',
      loginDto.toJson(),
    );
    try {
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print(responseData);
        final bool role = responseData['DT']['user']['is_admin'];
        if (!role) {
          return false;
        }
        final String token = responseData['DT']['token'];
        await _secureStorage.write(key: 'token', value: token);
        return true; // Đăng nhập thành công
      } else {
        return false; // Đăng nhập thất bại
      }
    } catch (error) {
      throw Exception('Failed to login: $error');
    }
  }
}
