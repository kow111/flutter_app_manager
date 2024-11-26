import 'dart:convert';
import 'package:app_manager/models/user/user_model.dart';
import 'package:app_manager/models/user/user_dto.dart';
import 'package:app_manager/services/api_client.dart';

class UserService {
  final ApiClient _apiClient = ApiClient();

  // Fetch the list of users (admin-specific)
  Future<Map<String, dynamic>> getUserAdmin({int page = 1}) async {
    final response = await _apiClient.getPrivate('/user?page=$page');
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> userData = responseData['DT']['users'];
        int totalPage = responseData['DT']['totalPages'];
        return {
          'users': userData.map((json) => User.fromJson(json)).toList(),
          'totalPage': totalPage,
        };
      } else {
        throw Exception('Failed to load users');
      }
    } catch (error) {
      throw Exception('Failed to load users: $error');
    }
  }

  // Update user details for admin
  Future<bool> updateUserAdmin(String id, UserDTO data) async {
    try {
      var response =
          await _apiClient.putPrivate('/user/update/$id', data.toJson());
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update user');
      }
    } catch (error) {
      throw Exception('Failed to update user: $error');
    }
  }
}
