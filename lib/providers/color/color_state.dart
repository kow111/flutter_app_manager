part of 'color_cubit.dart';

@immutable
sealed class ColorState {}

final class ColorInitial extends ColorState {}

final class ColorLoading extends ColorState {}

final class ColorSuccess extends ColorState {
  final List<Color> colors;

  ColorSuccess(this.colors);
}

final class ColorFailure extends ColorState {
  final String error;

  ColorFailure(this.error);
}
