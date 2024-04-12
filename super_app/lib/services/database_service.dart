// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:isar/isar.dart';
import 'package:js_runtime/utils/logger.dart';
import 'package:super_app/app/types.dart';

import '../models/models.dart';
import '../utils/file_utils.dart';

class DatabaseService {
  final Isar isar;
  DatabaseService({required this.isar});

  static final _logger = Logger("DatabaseService");

  Stream extensionsChange() => isar.extensions.watchLazy();
  Stream booksChange() => isar.books.watchLazy();

  Stream watchTrackById(int id) => isar.trackReads.watchObjectLazy(id);

  final StreamController<TrackRead> _trackStreamController =
      StreamController.broadcast();

  final StreamController<BookMessage> _booksStreamController =
      StreamController.broadcast();

  Stream<TrackRead> get trackStream => _trackStreamController.stream;

  Stream<BookMessage> get booksStream => _booksStreamController.stream;

  void _pushBookStream(Book book, MessageType type) {
    _booksStreamController.add(BookMessage(type: type, book: book));
    _logger.log("TYPE : $type\nBook name : ${book.name}\nBookId : ${book.id}",
        name: "pushBookStream");
  }

  Future<Book?> insertBook(Book book) async {
    try {
      final bookId = isar.writeTxnSync(() => isar.books.putSync(book));
      _logger.info("insertBook bookId =${book.id}");

      final bookLocal = await isar.books.get(bookId);
      _pushBookStream(bookLocal!, MessageType.ADD);
      return bookLocal;
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
      _pushBookStream(book, MessageType.UPDATE);
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
            await isar.chapters.deleteAll(chapterIds);
          }
          if (genreIds.isNotEmpty) {
            await isar.genres.deleteAll(genreIds);
          }
          if (trackReadId != null) {
            await isar.trackReads.delete(trackReadId);
          }
        }
      });
      _pushBookStream(book, MessageType.DELETE);

      _logger.info("deleteBook bookId =${book.id}");
      return book;
    } catch (err) {
      _logger.error("deleteBook err :${err.toString()}");
      rethrow;
    }
  }

  Future<Chapter> updateChapter(Chapter chapter) async {
    try {
      await isar.writeTxn(() => isar.chapters.put(chapter));
      _logger.info("updateChapter chapterId =${chapter.id}");

      return chapter;
    } catch (err) {
      _logger.error("updateChapter err :${err.toString()}");
      rethrow;
    }
  }

  Future<dynamic> updateBookData(
      {required Book book,
      required TrackRead trackRead,
      required Chapter chapter}) async {
    _logger.log("", name: "updateTrackAndChapter");

    await isar.writeTxn(() => Future.wait([
          isar.books.put(book),
          isar.trackReads.put(trackRead),
          isar.chapters.put(chapter)
        ]));

    final bookLocal = await getBookById(book.id!);
    _pushBookStream(bookLocal!, MessageType.UPDATE);
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

  // Future<List<Chapter>> getChaptersByBookId(int bookId) {
  // // return  isar.books.filter()
  // }

  Future<List<Book>> getListBook(ExtensionType type) async {
    try {
      return type == ExtensionType.all
          ? isar.books.where().sortByUpdateAtDesc().findAll()
          : isar.books
              .filter()
              .typeEqualTo(type)
              .sortByUpdateAtDesc()
              .findAll();
    } catch (err) {
      _logger.error(err, name: "getListBook");
      rethrow;
    }
  }

  Future<List<Book>> searchBookByName(
      String name, List<ExtensionType> types) async {
    try {
      return isar.books
          .filter()
          .nameContains(name)
          .anyOf(types, (q, element) => q.typeEqualTo(element))
          .sortByUpdateAtDesc()
          .findAll();
    } catch (err) {
      _logger.error(err, name: "searchBookByName");
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

  Future<bool> updateExtensionByUrl(
      List<int> bytes, String url, int extId) async {
    try {
      final ext = await FileUtils.zipFileToExtension(bytes, url);
      final id = await isar
          .writeTxn(() => isar.extensions.put(ext.copyWith(id: extId)));
      _logger.info("extId : $id");
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

  Future<void> close() async {
    _trackStreamController.close();
    _booksStreamController.close();
  }
}

enum MessageType { ADD, UPDATE, DELETE }

class BookMessage {
  final MessageType type;
  final Book book;
  const BookMessage({
    required this.type,
    required this.book,
  });

  BookMessage copyWith({
    MessageType? type,
    Book? book,
  }) {
    return BookMessage(
      type: type ?? this.type,
      book: book ?? this.book,
    );
  }

  @override
  bool operator ==(covariant BookMessage other) {
    if (identical(this, other)) return true;

    return other.type == type && other.book == book;
  }

  @override
  int get hashCode => type.hashCode ^ book.hashCode;
}
