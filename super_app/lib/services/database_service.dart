import 'package:collection/collection.dart';
import 'package:isar/isar.dart';
import 'package:js_runtime/utils/logger.dart';

import '../models/models.dart';
import '../utils/file_utils.dart';

class DatabaseService {
  final Isar isar;
  const DatabaseService({required this.isar});

  static final _logger = Logger("DatabaseService");
  // Future<List<Book>> getListBook() async {
  //   try {
  //     return [];
  //   } catch (err) {
  //     _logger.error(err, name: "getListBook");
  //     rethrow;
  //   }
  // }

  Stream extensionsChange() => isar.extensions.watchLazy();

  Future<Book> insertBook(Book book) async {
    try {
      isar.writeTxnSync(() {
        isar.books.putSync(book);
      });
      _logger.info("insertBook bookId =${book.id}");
      return book;
    } catch (err) {
      _logger.error("insertBook err :${err.toString()}");
      rethrow;
    }
  }

  Future<Book> addChaptersInBook(
      {required Book book, required List<Chapter> chapters}) async {
    try {
      book.chapters.addAll(chapters);
      isar.writeTxnSync(() {
        book.chapters.saveSync();
      });
      return book;
    } catch (error) {
      rethrow;
    }
  }

  Future<Book> deleteBook(Book book) async {
    try {
      List<int> chapterIds = [];
      List<int> genreIds = [];
      int? trackReadId;

      if (book.chapters.isNotEmpty) {
        chapterIds = book.chapters.map((e) => e.id!).toList();
      }
      if (book.genres.isNotEmpty) {
        genreIds = book.genres.map((e) => e.id!).toList();
      }
      if (book.trackRead.value != null) {
        trackReadId = book.trackRead.value!.id!;
      }

      await isar.writeTxn(() async {
        final isDelete = await isar.books.delete(book.id!);
        if (isDelete) {
          if (chapterIds.isNotEmpty) {
            isar.chapters.deleteAll(chapterIds);
          }
          if (genreIds.isNotEmpty) {
            isar.genres.deleteAll(genreIds);
          }
          if (trackReadId != null) {
            isar.trackReads.delete(trackReadId);
          }
        }
      });
      _logger.info("deleteBook bookId =${book.id}");
      return book;
    } catch (err) {
      _logger.error("deleteBook err :${err.toString()}");
      rethrow;
    }
  }

  Future<Chapter> updateChapter(Chapter chapter) async {
    try {
      isar.writeTxnSync(() => isar.chapters.put(chapter));
      _logger.info("updateChapter chapterId =${chapter.id}");

      return chapter;
    } catch (err) {
      _logger.error("updateChapter err :${err.toString()}");
      rethrow;
    }
  }

  Future<TrackRead> updateTrackRead(TrackRead trackRead) async {
    try {
      isar.writeTxnSync(
        () => isar.trackReads.putSync(trackRead),
      );
      _logger.info("updateTrackRead trackRead =${trackRead.id}");

      return trackRead;
    } catch (err) {
      _logger.error("updateTrackRead err :${err.toString()}");
      rethrow;
    }
  }

  Future<Book?> getBookById(int bookId) async {
    try {
      return isar.books.get(bookId);
    } catch (err) {
      _logger.error(err, name: "getListBook");
      rethrow;
    }
  }

  Future<Book?> getBookByUrl(String bookUrl) async {
    try {
      return isar.books.where().filter().urlEqualTo(bookUrl).findFirst();
    } catch (err) {
      _logger.error(err, name: "getListBook");
      rethrow;
    }
  }

  Future<List<Book>> getListBook() async {
    try {
      return isar.books.where().sortByUpdateAtDesc().findAll();
    } catch (err) {
      _logger.error(err, name: "getListBook");
      rethrow;
    }
  }

  Future<bool> insertExtensionByUrl(List<int> bytes, String url) async {
    try {
      final ext = await FileUtils.zipFileToExtension(bytes, url);
      final extId = await isar.writeTxn(() => isar.extensions.put(ext));
      _logger.info("extId : $extId");
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<List<Extension>> getListExtension() async {
    final exts = await isar.extensions.where().sortByUpdateAtDesc().findAll();
    _logger.info("Exts length = ${exts.length}");
    return exts;
  }

  Future<Extension?> getExtensionById(Id id) => isar.extensions.get(id);

  Future<bool> deleteExtensionById(Id id) =>
      isar.writeTxn(() => isar.extensions.delete(id));

  Future<int> updateExtension(Extension extension) =>
      isar.writeTxn(() => isar.extensions.put(extension));

  Future<Extension?> getExtensionBySource(String source) async {
    final exts = await isar.extensions.where().findAll();
    return exts.firstWhereOrNull((elm) {
      RegExp regExp = RegExp(elm.metadata.regexp!);
      if (regExp.hasMatch(source)) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<Extension?> get getExtensionFirst async {
    return isar.extensions.where().sortByUpdateAtDesc().findFirst();
  }
}
