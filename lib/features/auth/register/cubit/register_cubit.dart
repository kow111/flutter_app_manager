import 'package:app_manager/repositories/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository authRepository;

  RegisterCubit(this.authRepository) : super(RegisterInitial());

  Future<void> register(String email, String password) async {
    emit(RegisterLoading());
    try {
      final bool isRegistered = await authRepository.register(email, password);
      if (isRegistered) {
        emit(RegisterSuccess());
      } else {
        emit(RegisterFailure('Registration failed! Please try again.'));
      }
    } catch (error) {
      emit(RegisterFailure('Failed to register: $error'));
    }
  }
}
