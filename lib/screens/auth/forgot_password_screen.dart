import 'package:app_manager/features/auth/forget_password/cubit/forgot_password_cubit.dart';
import 'package:app_manager/features/auth/otp/cubit/otp_cubit.dart';
import 'package:app_manager/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final String email;
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  ForgotPasswordScreen({required this.email});

  void _onVerifyOtpPressed(BuildContext context) {
    final String otp = _otpController.text;
    final String password = _passwordController.text;
    context.read<ForgotPasswordCubit>().resetPassword(email, password, otp);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordCubit(AuthRepository()),
      child: Scaffold(
        appBar: AppBar(title: Text("Reset Password")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text("Please enter the OTP sent to $email"),
              TextFormField(
                controller: _otpController,
                decoration: InputDecoration(labelText: "OTP"),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "New Password"),
              ),
              SizedBox(height: 16),
              BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
                listener: (context, state) {
                  if (state is ForgotPasswordSuccess) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login',
                      (route) => false,
                    );
                  } else if (state is ForgotPasswordFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ForgotPasswordLoading) {
                    return CircularProgressIndicator();
                  }
                  return ElevatedButton(
                    onPressed: () => _onVerifyOtpPressed(context),
                    child: Text("Verify OTP"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
