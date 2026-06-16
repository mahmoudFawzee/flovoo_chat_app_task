import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);
  final _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  bool isDarkMode(BuildContext context) {
    final currentBrightness = Theme.of(context).brightness;

    if (currentBrightness == Brightness.dark) {
      return true;
    }
    return false;
  }

  void toggleTheme(BuildContext context) {
    if (!isClosed) emit(isDarkMode(context) ? ThemeMode.light : ThemeMode.dark);
  }
}
