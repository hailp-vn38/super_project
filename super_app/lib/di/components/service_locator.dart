import 'package:dio_client/index.dart';
import 'package:get_it/get_it.dart';
import 'package:js_runtime/js_runtime.dart';
import 'package:super_app/db/db_store.dart';
import 'package:super_app/services/database_service.dart';
import 'package:super_app/services/download_service.dart';
import 'package:super_app/services/settings_service.dart';

import '../modules/local_module.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerSingletonAsync<DBStore>(() => LocalModule.provideDBStore());
  getIt.registerSingletonAsync<JsRuntime>(() => LocalModule.provideJsRuntime());

  getIt.registerSingleton(DioClient());

  getIt.registerSingletonWithDependencies(
      () => SettingService(box: getIt<DBStore>().setting),
      dependsOn: [DBStore]);

  getIt.registerSingletonWithDependencies(
      () => DatabaseService(isar: getIt<DBStore>().isar),
      dependsOn: [DBStore]);

  getIt.registerSingletonWithDependencies(
      () => DownloadService(
          isar: getIt<DBStore>().isar, jsRuntime: getIt<JsRuntime>()),
      dependsOn: [DBStore, JsRuntime]);
}
