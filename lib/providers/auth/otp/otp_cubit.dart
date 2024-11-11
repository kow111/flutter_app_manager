import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:app_manager/repositories/auth_repository.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final AuthRepository authRepository;

  OtpCubit(this.authRepository) : super(OtpInitial());

  Future<void> verifyOtp(String email, String otp) async {
    emit(OtpLoading());
    try {
      final bool isOtpValid = await authRepository.verifyOtp(email, otp);
      if (isOtpValid) {
        emit(OtpSuccess());
      } else {
        emit(OtpFailure('Invalid OTP! Please try again.'));
      }
    } catch (error) {
      emit(OtpFailure('Failed to verify OTP: $error'));
    }
  }

  Future<void> sendOtp(String email) async {
    emit(OtpLoading());
    try {
      await authRepository.sendOtp(email);
      emit(OtpSuccess());
    } catch (error) {
      emit(OtpFailure('Failed to send OTP: $error'));
    }
  }
}
