import 'package:app_manager/providers/auth/login/login_cubit.dart';
import 'package:app_manager/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _onLoginPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<LoginCubit>().login(
            _emailController.text,
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(AuthRepository()),
      child: Scaffold(
        appBar: AppBar(title: Text("Login")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "Email"),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter email' : null,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter password' : null,
                ),
                SizedBox(height: 16),
                BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                    if (state is LoginSuccess) {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/home', (route) => false);
                    } else if (state is LoginFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error)),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is LoginLoading) {
                      return CircularProgressIndicator();
                    }
                    return ElevatedButton(
                      onPressed: () => _onLoginPressed(context),
                      child: Text("Login"),
                    );
                  },
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/register');
                  },
                  child: Text("Don't have an account? Register"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/forgot_password');
                  },
                  child: Text("Forgot password?"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
