import 'package:flutter/material.dart';
import 'package:app_manager/models/user/user_model.dart';
import 'package:app_manager/repositories/user_repository.dart';
import 'package:app_manager/models/user/user_dto.dart';

class UserDetailsScreen extends StatefulWidget {
  final User user;

  const UserDetailsScreen({super.key, required this.user});

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  bool _isVerified = false;
  bool _isAdmin = false;
  bool _isActive = false;

  final UserRepository _userRepository = UserRepository();
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);
    _isVerified = widget.user.isVerified;
    _isAdmin = widget.user.isAdmin;
    _isActive = widget.user.isActive;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Function to update user
  Future<void> _updateUser() async {
    setState(() {
      _isUpdating = true;
    });

    try {
      final updatedUser = UserDTO(
        username: _usernameController.text,
        isVerified: _isVerified,
        isAdmin: _isAdmin,
        isActive: _isActive,
      );

      final success =
          await _userRepository.updateUser(widget.user.id, updatedUser);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User updated successfully')));

        // Trả về trạng thái cập nhật thành công
        Navigator.pop(context, true);
      } else {
        throw Exception('Failed to update user');
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details: ${widget.user.username}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Verified:'),
                  Switch(
                    value: _isVerified,
                    onChanged: (value) {
                      setState(() {
                        _isVerified = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Admin:'),
                  Switch(
                    value: _isAdmin,
                    onChanged: (value) {
                      setState(() {
                        _isAdmin = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Active:'),
                  Switch(
                    value: _isActive,
                    onChanged: (value) {
                      setState(() {
                        _isActive = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _isUpdating
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _updateUser();
                        }
                      },
                      child: const Text('Cập nhật'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
