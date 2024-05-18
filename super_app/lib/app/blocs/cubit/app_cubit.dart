import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js_runtime/utils/logger.dart';
import 'package:super_app/models/models.dart';
import 'package:super_app/services/database_service.dart';
import 'package:super_app/services/settings_service.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit(
      {required SettingService settingService,
      required DatabaseService databaseService})
      : _settingService = settingService,
        _databaseService = databaseService,
        super(const AppState(themeMode: ThemeMode.system));

  final SettingService _settingService;
  final DatabaseService _databaseService;
  final _logger = Logger("AppCubit");

  void onInit() async {
    final theme = await _settingService.getThemeMode;
    emit(state.copyWith(themeMode: theme));
  }

  void onChangeThemeMode(ThemeMode themeMode) async {
    await _settingService.setThemeMode(themeMode);
    emit(state.copyWith(themeMode: themeMode));
  }

  Future<int?> addLibrary({
    required Book book,
    required List<Chapter> chapters,
  }) async {
    try {
      final bookId = await _databaseService.insertBook(book);
      if (bookId == null) return null;
      for (var chapter in chapters) {
        chapter.bookId = bookId.id;
      }
      final add = await _databaseService.insertChapters(chapters: chapters);
      return bookId.id!;
    } catch (err) {
      _logger.error(err, name: "addLibrary");
      return null;
    }
  }
}
