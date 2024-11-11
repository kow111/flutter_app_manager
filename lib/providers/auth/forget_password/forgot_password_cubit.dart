import 'package:app_manager/repositories/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepository authRepository;
  ForgotPasswordCubit(this.authRepository) : super(ForgotPasswordInitial());

  Future<void> resetPassword(String email, String password, String otp) async {
    emit(ForgotPasswordLoading());
    try {
      final bool isEmailSent =
          await authRepository.resetPassword(email, otp, password);
      if (isEmailSent) {
        emit(ForgotPasswordSuccess());
      } else {
        emit(ForgotPasswordFailure('Failed to send email! Please try again.'));
      }
    } catch (error) {
      emit(ForgotPasswordFailure('Failed to send email: $error'));
    }
  }
}
