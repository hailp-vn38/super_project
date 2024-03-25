import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js_runtime/js_runtime.dart';
import 'package:js_runtime/utils/logger.dart';
import 'package:super_app/app/extensions/string_extension.dart';
import 'package:super_app/app/types.dart';
import 'package:super_app/models/models.dart';
import 'package:super_app/services/database_service.dart';

part 'explore_state.dart';

class ExploreCubit extends Cubit<ExploreState> {
  ExploreCubit(
      {required DatabaseService databaseService, required JsRuntime jsRuntime})
      : _database = databaseService,
        _runtime = jsRuntime,
        super(ExploreInitial()) {
    _extensionsStreamSubscription =
        _database.extensionsChange().listen((_) async {
      final state = this.state;
      if (state is ExploreEmptyExtension) {
        final ext = await _database.getExtensionFirst;
        if (ext != null) {
          onInit();
        }
      } else if (state is ExploreLoadedExtension) {
        final tmp = await _database.getExtensionById(state.extension.id!);
        if (tmp == null) {
          final ext = await _database.getExtensionFirst;
          if (ext == null) {
            emit(ExploreEmptyExtension());
          } else {
            onInit();
          }
        }
      }
    });
  }

  final _logger = Logger("ExploreCubit");

  final DatabaseService _database;
  final JsRuntime _runtime;

  late StreamSubscription _extensionsStreamSubscription;

  void onInit() async {
    try {
      emit(ExploreLoadExtension());
      final extension = await _database.getExtensionFirst;
      if (extension == null) {
        emit(ExploreEmptyExtension());
      } else {
        emit(ExploreLoadedExtension(
            extension: extension, tabs: const [], status: StatusType.loading));
        getTabsByExtension();
      }
    } catch (error) {
      emit(const ExploreError("Loading extension error"));
    }
  }

  void getTabsByExtension() async {
    _logger.info("init", name: "getTabsByExtension");
    final state = this.state;
    if (state is! ExploreLoadedExtension) return;

    try {
      emit(state.copyWith(status: StatusType.loading));

      final result =
          await _runtime.getTabs<List<dynamic>>(state.extension.getTabsScript);

      final tabs = result
          .map<ItemTabExplore>(
            (e) => ItemTabExplore.fromMap(e),
          )
          .toList();
      emit(state.copyWith(status: StatusType.loaded, tabs: tabs));
      _logger.info("tabs = ${tabs.length}", name: "getTabsByExtension");
    } on JsRuntimeException catch (error) {
      _logger.log(error.message);
    } catch (error) {
      emit(state.copyWith(status: StatusType.error));
    }
  }

  Future<List<Book>> onGetListBook(String url, int page) async {
    final state = this.state;
    if (state is! ExploreLoadedExtension) return [];

    try {
      final result = await _runtime.getList<List<dynamic>>(
        url: url.replaceUrl(state.extension.source),
        page: page,
        jsScript: state.extension.getHomeScript,
      );
      return result.map<Book>((e) => Book.fromMap(e)).toList();
    } catch (error) {
      _logger.error(error, name: "onGetListBook");
      rethrow;
    }
  }

  Future<List<Genre>> onGetListGenre() async {
    final state = this.state;
    if (state is! ExploreLoadedExtension) return [];

    try {
      final result = await _runtime.getGenre<List<dynamic>>(
          url: state.extension.source, source: state.extension.getGenreScript!);
      return result.map<Genre>((e) => Genre.fromMap(e)).toList();
    } on JsRuntimeException catch (error) {
      _logger.log(error.message);
    } catch (error) {
      _logger.error(error, name: "onGetListGenre");
    }
    return [];
  }

  Future<List<Extension>> getListExtension() => _database.getListExtension();

  void onChangeExtension(Extension extension) async {
    emit(ExploreLoadedExtension(
        extension: extension, tabs: const [], status: StatusType.loading));
    await Future.delayed(const Duration(milliseconds: 50));
    getTabsByExtension();
    _database.updateExtension(extension.copyWith(updateAt: DateTime.now()));
  }

  @override
  Future<void> close() {
    _extensionsStreamSubscription.cancel();
    return super.close();
  }
}
