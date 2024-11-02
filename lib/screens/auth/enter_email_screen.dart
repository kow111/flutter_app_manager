import 'package:app_manager/features/auth/otp/cubit/otp_cubit.dart';
import 'package:app_manager/repositories/auth_repository.dart';
import 'package:app_manager/screens/auth/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnterEmailScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  void _onSendOtp(BuildContext context) {
    context.read<OtpCubit>().sendOtp(_emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OtpCubit(AuthRepository()),
      child: Scaffold(
        appBar: AppBar(title: Text("Enter Email")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Căn trái cho các widget trong cột
            children: [
              Text("Please enter your email"),
              SizedBox(height: 8), // Khoảng cách giữa văn bản và trường nhập
              TextFormField(
                controller: _emailController, // Sử dụng controller
                decoration: InputDecoration(labelText: "Email"),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your email' : null,
              ),
              SizedBox(height: 16),
              BlocConsumer<OtpCubit, OtpState>(
                listener: (context, state) {
                  if (state is OtpSuccess) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>
                            ForgotPasswordScreen(email: _emailController.text),
                      ),
                    );
                  } else if (state is OtpFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is OtpLoading) {
                    return Center(
                        child:
                            CircularProgressIndicator()); // Trung tâm để chỉ rõ hơn
                  }
                  return ElevatedButton(
                    onPressed: () => _onSendOtp(context),
                    child: Text("Gửi mã OTP"),
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
