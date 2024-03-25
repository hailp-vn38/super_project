import 'dart:convert';

import 'package:dio_client/index.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js_runtime/utils/logger.dart';
import 'package:super_app/app/constants/constants.dart';
import 'package:super_app/app/types.dart';
import 'package:super_app/models/models.dart';
import 'package:super_app/services/database_service.dart';

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

  void onInit() {
    checkUpdateExtensions();
  }

  Future<void> getCurrentExtensions() async {
    try {
      emit(state.copyWith(
          extensions: const StateRes(status: StatusType.loading)));
      final exts = await _databaseService.getListExtension();
      _logger.info("Ext installed = ${exts.length} ",
          name: "getCurrentExtensions");

      emit(state.copyWith(
          extensions: StateRes(status: StatusType.loaded, data: exts)));
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

  Future<bool> onInstallExt(Metadata metadata) async {
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

  Future<void> checkUpdateExtensions() async {
    try {
      emit(state.copyWith(
          extsUpdate: const StateRes(status: StatusType.loading)));

      final res = await _dioClient.get(Constants.urlExtensions);
      final data =
          List.from(jsonDecode(res)).map((e) => Metadata.fromMap(e)).toList();
      Map<String, Metadata> mapData = {for (var item in data) item.name!: item};
      List<Metadata> listUpdate = [];
      for (var ext in state.extensions.data!) {
        if (mapData.containsKey(ext.metadata.name) &&
            ext.metadata.version! != mapData[ext.metadata.name]!.version!) {
          listUpdate.add(mapData[ext.metadata.name]!);
        }
      }
      _logger.info("Update = ${listUpdate.length}",
          name: "checkUpdateExtensions");

      emit(state.copyWith(
          extsUpdate: StateRes(status: StatusType.loaded, data: listUpdate)));
    } catch (err) {
      emit(state.copyWith(
          allExtension: const StateRes(
              status: StatusType.error, message: "Update extensions err")));

      _logger.error(err, name: "checkUpdateExtensions");
    }
  }
}
