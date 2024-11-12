import 'package:app_manager/models/color/color.dart';
import 'package:app_manager/services/color_service.dart';

class ColorRepository {
  final ColorService _colorService = ColorService();
  Future<List<Color>> fetchColors() async {
    return await _colorService.getColors();
  }
}
