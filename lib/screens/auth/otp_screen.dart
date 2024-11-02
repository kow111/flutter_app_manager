// otp_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_manager/features/auth/otp/cubit/otp_cubit.dart';
import 'package:app_manager/repositories/auth_repository.dart';

class OtpScreen extends StatelessWidget {
  final String email;
  final TextEditingController _otpController = TextEditingController();

  OtpScreen({required this.email});

  void _onVerifyOtpPressed(BuildContext context) {
    context.read<OtpCubit>().verifyOtp(email, _otpController.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OtpCubit(AuthRepository()),
      child: Scaffold(
        appBar: AppBar(title: Text("Enter OTP")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text("Please enter the OTP sent to $email"),
              TextFormField(
                controller: _otpController,
                decoration: InputDecoration(labelText: "OTP"),
              ),
              SizedBox(height: 16),
              BlocConsumer<OtpCubit, OtpState>(
                listener: (context, state) {
                  if (state is OtpSuccess) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/home',
                      (route) => false,
                    );
                  } else if (state is OtpFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is OtpLoading) {
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
