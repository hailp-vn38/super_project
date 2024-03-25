import 'package:hive_flutter/hive_flutter.dart';
import 'package:isar/isar.dart';
import 'package:logging/logging.dart';
import 'package:super_app/models/book.dart';
import 'package:super_app/models/chapter.dart';
import 'package:super_app/models/extension.dart';
import 'package:super_app/models/genre.dart';
import 'package:super_app/models/track_read.dart';
import 'package:super_app/utils/directory_utils.dart';

class DBStore {
  final _logger = Logger("Database");
  late Isar _database;
  late Box _settings;
  Future<void> ensureInitialized() async {
    try {
      _logger.info("ensureInitialized");
      final pathDir = await DirectoryUtils.getDirDatabase;

      _settings = await Hive.openBox(
        "settings",
        path: pathDir,
      );

      _database = await Isar.open([
        ExtensionSchema,
        BookSchema,
        ChapterSchema,
        GenreSchema,
        TrackReadSchema
      ], directory: pathDir, name: "db");
    } catch (error) {
      _logger.warning(error);
      //
    }
  }

  Isar get isar => _database;
  Box get setting => _settings;
}
