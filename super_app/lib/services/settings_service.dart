import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingService {
  final Box box;
  const SettingService({required this.box});

  Future<ThemeMode> get getThemeMode async {
    final theme =
        await box.get(SettingsKey.theme, defaultValue: ThemeMode.system.name);
    return ThemeMode.values.firstWhere(
      (element) => element.name == theme,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    await box.put(SettingsKey.theme, themeMode.name);
  }
}

class SettingsKey {
  static const theme = "theme_mode";
}
