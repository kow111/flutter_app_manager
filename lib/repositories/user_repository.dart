import 'package:app_manager/models/user/user_model.dart';
import 'package:app_manager/models/user/user_dto.dart';
import 'package:app_manager/services/user_service.dart';

class UserRepository {
  final UserService _userService = UserService();

  // Fetch user data from the API
  Future<Map<String, dynamic>> fetchUserAdmin(int page) {
    return _userService.getUserAdmin(page: page);
  }

  // Update user data
  Future<bool> updateUser(String id, UserDTO data) {
    return _userService.updateUserAdmin(id, data);
  }
}
