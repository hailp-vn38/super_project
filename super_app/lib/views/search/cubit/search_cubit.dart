import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js_runtime/js_runtime.dart';
import 'package:super_app/app/types.dart';
import 'package:super_app/models/models.dart';
import 'package:super_app/services/database_service.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(
      {required DatabaseService databaseService,
      required JsRuntime jsRuntime,
      required Extension extension})
      : _databaseService = databaseService,
        _jsRuntime = jsRuntime,
        _extension = extension,
        super(const SearchState(status: StatusType.init, books: []));
  final DatabaseService _databaseService;
  Extension _extension;
  final JsRuntime _jsRuntime;

  late TextEditingController textEditingController;
  String? _message;

  Extension get extension => _extension;
  void onInit() {
    textEditingController = TextEditingController();
  }

  void onSearch() async {
    try {
      _message = null;
      emit(state.copyWith(status: StatusType.loading));

      final result = await _jsRuntime.getSearch<List<dynamic>>(
          keyWord: textEditingController.text,
          url: _extension.metadata.source!,
          jsScript: _extension.getSearchScript!,
          page: 1);

      emit(state.copyWith(
          status: StatusType.loaded,
          books: result.map<Book>((e) => Book.fromMap(e)).toList()));
    } on JsRuntimeException catch (error) {
      _message = error.message;
      emit(state.copyWith(status: StatusType.error));
    } catch (error) {
      emit(state.copyWith(status: StatusType.error));
    }
  }

  Future<List<Book>> onLoadMoreSearch(int page) async {
    List<Book> books = [];
    try {
      final result = await _jsRuntime.getSearch<List<dynamic>>(
          keyWord: textEditingController.text,
          url: _extension.metadata.source!,
          jsScript: _extension.getSearchScript!,
          page: page);
      books = result.map<Book>((e) => Book.fromMap(e)).toList();
    } catch (error) {
      //
    }
    return books;
  }
}
