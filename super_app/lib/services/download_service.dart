import 'package:isar/isar.dart';
import 'package:js_runtime/js_runtime.dart';

class DownloadService {
  final Isar isar;
  final JsRuntime jsRuntime;
  const DownloadService({required this.isar, required this.jsRuntime});
}
