import 'dart:convert';
import 'api_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // API đăng nhập
  Future<bool> login(String email, String password) async {
    var response = await _apiClient.postPublic(
      '/auth/login',
      {'email': email, 'password': password},
    );
    try {
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final bool role = responseData['DT']['is_admin'];
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
