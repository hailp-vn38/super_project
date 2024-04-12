import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js_runtime/js_runtime.dart';
import 'package:super_app/app/types.dart';
import 'package:super_app/models/models.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(
      {required JsRuntime jsRuntime,
      required Extension extension,
      String? searchWord})
      : _jsRuntime = jsRuntime,
        _extension = extension,
        _textEditingController = TextEditingController(text: searchWord),
        super(const SearchState(status: StatusType.init, books: []));
  final Extension _extension;
  final JsRuntime _jsRuntime;

  final TextEditingController _textEditingController;

  Extension get extension => _extension;

  TextEditingController get getTextEditingController => _textEditingController;
  void onInit() {
    if (_textEditingController.text != "") {
      onSearch();
    }
  }

  void onSearch() async {
    try {
      emit(state.copyWith(status: StatusType.loading));

      final result = await _jsRuntime.getSearch<List<dynamic>>(
          keyWord: _textEditingController.text,
          url: _extension.metadata.source!,
          jsScript: _extension.getSearchScript!,
          page: 1);

      emit(state.copyWith(
          status: StatusType.loaded,
          books: result.map<Book>((e) => Book.fromMap(e)).toList()));
    } on JsRuntimeException {
      emit(state.copyWith(status: StatusType.error));
    } catch (error) {
      emit(state.copyWith(status: StatusType.error));
    }
  }

  Future<List<Book>> onLoadMoreSearch(int page) async {
    List<Book> books = [];
    try {
      final result = await _jsRuntime.getSearch<List<dynamic>>(
          keyWord: _textEditingController.text,
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
