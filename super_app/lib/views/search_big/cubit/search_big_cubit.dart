// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js_runtime/js_runtime.dart';
import 'package:super_app/app/mixins/state.dart';
import 'package:super_app/app/types.dart';

import 'package:super_app/models/models.dart';
import 'package:super_app/services/database_service.dart';

part 'search_big_state.dart';

class SearchBigCubit extends Cubit<SearchBigState> {
  SearchBigCubit(
      {required DatabaseService databaseService, required JsRuntime jsRuntime})
      : _databaseService = databaseService,
        _jsRuntime = jsRuntime,
        super(const SearchBigState(
            status: StatusType.init,
            exts: [],
            stateRes: StateRes(status: StatusType.init),
            stateBooks: StateRes(status: StatusType.init)));
  final DatabaseService _databaseService;
  final JsRuntime _jsRuntime;

  String _jsCore = "";

  TextEditingController textEditingController = TextEditingController();

  List<Extension> _exts = [];

  List<ExtensionType> types = [
    ExtensionType.comic,
    ExtensionType.movie,
    ExtensionType.novel
  ];

  void onInit() async {
    emit(state.copyWith(status: StatusType.loading));
    _jsCore = await rootBundle.loadString("assets/js/extension.js");
    final exts = await _databaseService.getListExtension();
    emit(state.copyWith(status: StatusType.loaded, exts: exts));
  }

  void onChangeType(List<ExtensionType> value) {
    types = value;
  }

  // Future<List<Book>> search(Extension extension) async {
  //   return compute(
  //       searchByExtension,
  //       SearchExtensionParams(
  //           jsCore: _jsCore,
  //           url: extension.source,
  //           searchWord: textEditingController.text,
  //           jsScript: extension.getSearchScript!));
  // }

  Future<void> onSearch() async {
    if (textEditingController.text == "") return;
    await Future.wait([onSearchByLib(), onSearchByExtension()]);
  }

  Future<void> onSearchByExtension() async {
    emit(state.copyWith(stateRes: const StateRes(status: StatusType.loading)));
    if (_exts.isEmpty) {
      _exts = await _databaseService.getListExtension();
      // _exts = [_exts[2]];
    }
    if (types.isNotEmpty) {
      List<Extension> tmp = [];
      for (var type in types) {
        final exts =
            _exts.where((element) => element.metadata.type == type).toList();
        tmp.addAll(exts);
      }
      await Future.delayed(const Duration(milliseconds: 500));

      emit(state.copyWith(
          stateRes: StateRes(status: StatusType.loaded, data: tmp)));
    } else {
      await Future.delayed(const Duration(milliseconds: 500));

      emit(state.copyWith(
          stateRes: StateRes(status: StatusType.loaded, data: _exts)));
    }
  }

  Future<void> onSearchByLib() async {
    emit(
        state.copyWith(stateBooks: const StateRes(status: StatusType.loading)));
    final books = await _databaseService.searchBookByName(
        textEditingController.text, types);
    emit(state.copyWith(
        stateBooks: StateRes(status: StatusType.loaded, data: books)));
  }

  void onCloseDialog() {
    if (textEditingController.text == "") return;
    onSearch();
  }

  Future<List<Book>> searchByExtension(Extension extension) async {
    if (textEditingController.text == "") return [];

    final result = await _jsRuntime.getSearch<List<dynamic>>(
        keyWord: textEditingController.text,
        url: extension.source,
        jsScript: extension.getSearchScript!,
        page: 1);
    return result.map<Book>((e) => Book.fromMap(e)).toList();
  }
}

class SearchExtension {
  final Extension extension;
  Completer search;
  SearchExtension({
    required this.extension,
    required this.search,
  });
}

class SearchExtensionParams {
  final String searchWord;
  final String url;
  final String jsScript;
  final String jsCore;
  SearchExtensionParams(
      {required this.searchWord,
      required this.url,
      required this.jsScript,
      required this.jsCore});
}

Future<List<Book>> searchByExtension(SearchExtensionParams params) async {
  try {
    final jsRuntime = JsRuntime();
    final isReady = await jsRuntime.initRuntimeTst(jsExtension: params.jsCore);

    if (!isReady) return Future.error(Exception("jsRuntime init Error"));
    final result = await jsRuntime.getSearch<List<dynamic>>(
        keyWord: params.searchWord,
        url: params.url,
        jsScript: params.jsScript,
        page: 1);
    return result.map<Book>((e) => Book.fromMap(e)).toList();
  } catch (error) {
    //
  }
  return [];
}
