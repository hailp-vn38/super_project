import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:super_app/models/extension.dart';
import 'package:archive/archive_io.dart';

class FileUtils {
  static Future<Extension> zipFileToExtension(
      List<int> bytes, String url) async {
    final archive = ZipDecoder().decodeBytes(bytes);
    final fileExt =
        archive.files.firstWhereOrNull((item) => item.name == "extension.json");
    if (fileExt != null) {
      final contentString = utf8.decode(fileExt.content as List<int>);
      Extension ext = Extension.fromJson(contentString);
      Script script = ext.script;
      Metadata metadata = ext.metadata;
      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
          final data = file.content as List<int>;
          switch (filename) {
            case "src/tabs.js":
              final string = utf8.decode(data);
              script = script.copyWith(tabs: string);
              break;
            case "src/home.js":
              final string = utf8.decode(data);
              script = script.copyWith(home: string);
              break;
            case "src/detail.js":
              final string = utf8.decode(data);
              script = script.copyWith(detail: string);
              break;
            case "src/chapters.js":
              final string = utf8.decode(data);
              script = script.copyWith(chapters: string);
              break;
            case "src/chapter.js":
              final string = utf8.decode(data);
              script = script.copyWith(chapter: string);
              break;
            case "src/search.js":
              final string = utf8.decode(data);
              script = script.copyWith(search: string);
              break;
            case "src/genre.js":
              final string = utf8.decode(data);
              script = script.copyWith(genre: string);
              break;
            case "icon.png":
              final base64Icon = base64Encode(data);
              metadata = metadata.copyWith(icon: base64Icon);
              break;
          }
        }
      }
      ext = ext.copyWith(
          metadata: metadata.copyWith(path: url),
          script: script,
          updateAt: DateTime.now());
      if (ext.script.tabs != null &&
          ext.script.home != null &&
          ext.script.detail != null &&
          ext.script.chapters != null &&
          ext.script.chapter != null) {
        return ext;
      } else {
        throw Exception("Error");
      }
    }
    throw Exception("Error");
  }
}
