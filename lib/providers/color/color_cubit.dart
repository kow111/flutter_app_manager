import 'package:app_manager/models/color/color.dart';
import 'package:app_manager/repositories/color_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'color_state.dart';

class ColorCubit extends Cubit<ColorState> {
  final ColorRepository colorRepository;
  ColorCubit(this.colorRepository) : super(ColorInitial());

  Future<void> getColors() async {
    if (state is ColorLoading) return;
    emit(ColorLoading());
    try {
      final colors = await colorRepository.fetchColors();
      emit(ColorSuccess(colors));
    } catch (error) {
      emit(ColorFailure('Failed to load colors: $error'));
    }
  }
}
