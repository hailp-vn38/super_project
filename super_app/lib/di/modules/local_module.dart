import 'package:js_runtime/js_runtime.dart';
import 'package:super_app/db/db_store.dart';

abstract class LocalModule {
  static Future<DBStore> provideDBStore() async {
    final databaseService = DBStore();
    await databaseService.ensureInitialized();
    return databaseService;
  }

  static Future<JsRuntime> provideJsRuntime() async {
    final jsRuntime = JsRuntime();
    await jsRuntime.initRuntime();
    return jsRuntime;
  }
}
