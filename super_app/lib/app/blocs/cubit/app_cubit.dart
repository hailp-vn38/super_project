import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_app/di/components/service_locator.dart';
import 'package:super_app/services/settings_service.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({required SettingService settingService})
      : _settingService = settingService,
        super(const AppState(themeMode: ThemeMode.system));

  final SettingService _settingService;

  void onInit() async {

    
    final theme = await _settingService.getThemeMode;
    emit(state.copyWith(themeMode: theme));
  }

  void onChangeThemeMode(ThemeMode themeMode) async {
    await _settingService.setThemeMode(themeMode);
    emit(state.copyWith(themeMode: themeMode));
  }
}
