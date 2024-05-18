import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dio_client/index.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js_runtime/utils/logger.dart';
import 'package:super_app/app/constants/constants.dart';
import 'package:super_app/app/mixins/handler_concurrent.dart';
import 'package:super_app/app/types.dart';
import 'package:super_app/models/models.dart';
import 'package:super_app/services/database_service.dart';
import 'package:super_app/utils/file_utils.dart';

part 'extensions_state.dart';

class ExtensionsCubit extends Cubit<ExtensionsState> {
  ExtensionsCubit(
      {required DatabaseService databaseService, required DioClient dioClient})
      : _databaseService = databaseService,
        _dioClient = dioClient,
        super(ExtensionsState.init());
  final DatabaseService _databaseService;
  final DioClient _dioClient;

  final _logger = Logger("ExtensionsCubit");

  int indexTab = 0;

  late HandlerConcurrent<Extension, ExtensionEntry<Extension>>
      _handlerConcurrent;

  Future<Extension?> check(ExtensionEntry<Extension> entry) async {
    try {
      final result = await _dioClient
          .get(entry.extension.metadata.path!.replaceAll("zip", "json"));

      final map = jsonDecode(result);
      if (map != null && map["metadata"] != null) {
        Metadata meta = Metadata.fromMap(map["metadata"]);
        if (meta.version! > entry.extension.metadata.version!) {
          meta.icon = entry.extension.metadata.icon;
          meta.path = entry.extension.metadata.path;
          return entry.extension.copyWith(metadata: meta);
        }
      }
    } catch (err) {
      //
    }
    return null;
  }

  void onInit() {
    _handlerConcurrent =
        HandlerConcurrent<Extension, ExtensionEntry<Extension>>(
            maxConcurrent: 1, fun: check);
  }

  void onChangeIndexTab(int index) {
    indexTab = index;
  }

  Future<void> getCurrentExtensions() async {
    try {
      emit(state.copyWith(
          extensions: const StateRes(status: StatusType.loading, data: [])));
      final exts = await _databaseService.getListExtension();
      _logger.info("Ext installed = ${exts.length} ",
          name: "getCurrentExtensions");

      emit(state.copyWith(
          extensions: StateRes(status: StatusType.loaded, data: exts)));
      checkExt();
    } catch (err) {
      emit(state.copyWith(
          extensions: const StateRes(
              status: StatusType.error, message: "Err get extensions")));

      _logger.error(err, name: "getCurrentExtensions");
    }
  }

  void getNetworkExtensions() async {
    try {
      emit(state.copyWith(
          allExtension: const StateRes(status: StatusType.loading)));
      final res = await _dioClient.get(Constants.urlExtensions);

      final data =
          List.from(jsonDecode(res)).map((e) => Metadata.fromMap(e)).toList();
      Map<String, Metadata> mapData = {for (var item in data) item.name!: item};

      for (var ext in state.extensions.data!) {
        if (mapData.containsKey(ext.metadata.name)) {
          mapData.remove(ext.metadata.name);
        }
      }
      _logger.info("All ext = ${mapData.length}", name: "getNetworkExtensions");

      emit(state.copyWith(
          allExtension: StateRes(
              status: StatusType.loaded, data: mapData.values.toList())));
    } catch (err) {
      emit(state.copyWith(
          allExtension: const StateRes(
              status: StatusType.error, message: "Err get extensions")));

      _logger.error(err, name: "getNetworkExtensions");
    }
  }

  Future<bool> onUninstallExt(Extension extension) async {
    final isDelete = await _databaseService.deleteExtensionById(extension.id!);
    if (!isDelete) return false;

    final exts = await _databaseService.getListExtension();
    emit(state.copyWith(
        extensions: StateRes(status: StatusType.loaded, data: exts),
        allExtension: state.allExtension.copyWith(
            data: [...state.allExtension.data!, extension.metadata])));
    return true;
  }

  Future<bool> onUninstallExtByMetadata(Metadata metadata) async {
    final ext = state.extensions.data!
        .firstWhereOrNull((ext) => ext.metadata.name == metadata.name);
    if (ext == null) return false;
    return onUninstallExt(ext);
  }

  Future<bool> onInstallByMetadata(Metadata metadata) async {
    final bytes = await DioClient().get(metadata.path!,
        options: Options(responseType: ResponseType.bytes));
    final installed =
        await _databaseService.insertExtensionByUrl(bytes, metadata.path!);
    if (!installed) return false;
    getCurrentExtensions();
    final data = state.allExtension.data!
        .where((el) => el.path != metadata.path)
        .toList();
    emit(state.copyWith(
        allExtension: StateRes(status: StatusType.loaded, data: data)));
    return true;
  }

  Future<void> onInstallByFile(Extension ext) async {
    final installed = await _databaseService.insertExtension(ext);
    if (!installed) {
      // thông báo url sai đinh dạng
    } else {
      getCurrentExtensions();
    }
  }

  Future<void> onInstallByUrl(String url) async {
    try {
      if (!url.startsWith("http")) {
        // thông báo url sai đinh dạng
      }
      final bytes = await DioClient()
          .get(url, options: Options(responseType: ResponseType.bytes));

      final installed = await _databaseService.insertExtensionByUrl(bytes, url);
      if (!installed) {
        // thông báo url sai đinh dạng
      } else {
        getCurrentExtensions();
      }
    } catch (err) {
      _logger.error(err, name: "onInstallByUrl");
    }
  }

  void checkExt() {
    if (state.extensions.data!.isEmpty) {
      emit(state.copyWith(
          extsUpdate: const StateRes(status: StatusType.loaded, data: [])));
      return;
    }
    emit(state.copyWith(
        extsUpdate: const StateRes(status: StatusType.loading, data: [])));

    int step = 0;
    for (var ext in state.extensions.data ?? []) {
      _handlerConcurrent.run(ExtensionEntry(extension: ext)).then((value) {
        print("${ext.metadata.name} : update ${value != null}");
        step++;
        if (step == state.extensions.data!.length) {
          emit(state.copyWith(
              extsUpdate:
                  state.extsUpdate.copyWith(status: StatusType.loaded)));

          print("xong");
        }

        if (value != null) {
          emit(state.copyWith(
              extsUpdate: state.extsUpdate.copyWith(
                  data: [value.metadata, ...state.extsUpdate.data!])));
        }
      });
    }
  }

  Future<bool> onUpdateExt(Metadata metadata) async {
    try {
      final bytes = await DioClient().get(metadata.path!,
          options: Options(responseType: ResponseType.bytes));

      final ext = state.extensions.data!
          .firstWhereOrNull((ext) => ext.metadata.name == metadata.name);
      if (ext == null) return false;
      final installed = await _databaseService.updateExtensionByUrl(
          bytes, metadata.path!, ext.id!);
      if (!installed) return false;
      final data = state.extsUpdate.data!
          .where((el) => el.name != ext.metadata.name)
          .toList();
      emit(state.copyWith(
          extsUpdate: StateRes(status: StatusType.loaded, data: data)));
      getCurrentExtensions();
      return true;
    } catch (err) {
      return false;
    }
  }

  void pickFileZip() async {
    try {
      final bytes = await FileUtils.pickFileZip();
      if (bytes == null) return;

      await FileUtils.zipFileToExtension(bytes);
      await getCurrentExtensions();
    } catch (err) {
      _logger.error(err, name: "pickFileZip");
    }
  }

  @override
  Future<void> close() {
    _handlerConcurrent.close();
    return super.close();
  }
}
