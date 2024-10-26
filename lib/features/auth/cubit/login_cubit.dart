import 'package:app_manager/repositories/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;
  LoginCubit(this.authRepository) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      final bool isLoggedIn = await authRepository.login(email, password);
      if (isLoggedIn) {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure('Login failed! Please check your credentials.'));
      }
    } catch (error) {
      emit(LoginFailure('Failed to login: $error'));
    }
  }
}
