import 'package:flutter/material.dart';
import 'package:app_manager/models/user/user_model.dart';
import 'package:app_manager/repositories/user_repository.dart';
import 'package:app_manager/screens/user/user_detail_sceen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final UserRepository _userRepository = UserRepository();
  List<User> _users = [];
  int _totalPage = 1;
  int _currentPage = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    if (_isLoading) return; // Ngăn chặn việc gọi fetch khi đang tải
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _userRepository.fetchUserAdmin(_currentPage);
      setState(() {
        _users = response['users'];
        _totalPage = response['totalPage'];
      });
    } catch (error) {
      _showError(error.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _viewUserDetails(User user) async {
    final bool? isUpdated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailsScreen(user: user),
      ),
    );
    if (isUpdated == true) {
      _fetchUsers();
    }
  }

  Widget _buildUserList() {
    if (_users.isEmpty) {
      return const Center(child: Text('No users found.'));
    }

    return ListView.builder(
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        return ListTile(
          title: Text(user.username),
          subtitle: Text(user.email),
          onTap: () => _viewUserDetails(user),
        );
      },
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: _currentPage > 1
                ? () {
                    setState(() {
                      _currentPage--;
                    });
                    _fetchUsers();
                  }
                : null,
            icon: const Icon(Icons.arrow_left),
            label: const Text('Previous'),
          ),
          Text('Page $_currentPage of $_totalPage'),
          TextButton.icon(
            onPressed: _currentPage < _totalPage
                ? () {
                    setState(() {
                      _currentPage++;
                    });
                    _fetchUsers();
                  }
                : null,
            icon: const Icon(Icons.arrow_right),
            label: const Text('Next'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
      ),
      body: Column(
        children: [
          if (_isLoading)
            const LinearProgressIndicator(), // Hiển thị thanh loading khi đang tải
          Expanded(child: _buildUserList()),
          _buildPagination(),
        ],
      ),
    );
  }
}
