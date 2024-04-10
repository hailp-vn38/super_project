import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js_runtime/utils/logger.dart';
import 'package:super_app/app/mixins/state.dart';
import 'package:super_app/app/types.dart';
import 'package:super_app/models/book.dart';
import 'package:super_app/services/database_service.dart';

part 'library_state.dart';

class LibraryCubit extends Cubit<LibraryState> {
  LibraryCubit({required this.databaseService})
      : super(const LibraryState(
            stateBooks: StateRes(
              status: StatusType.init,
            ),
            type: ExtensionType.all));

  final _logger = Logger("LibraryCubit");
  final DatabaseService databaseService;
  late StreamSubscription _bookStreamSubscription;
  void onInit() {
    _bookStreamSubscription = databaseService.booksStream.listen(
      (bookMessage) {
        final type = bookMessage.type;
        final book = bookMessage.book;
        switch (type) {
          case MessageType.ADD:
            emit(state.copyWith(
                stateBooks:
                    state.stateBooks.copyWith(data: [book, ...getListBook])));
            break;
          case MessageType.UPDATE:
            // final listBook =
            //     getListBook.map((el) => el.id == book.id ? book : el).toList();
            // emit(state.copyWith(
            //     stateBooks: state.stateBooks.copyWith(data: listBook)));

            final listBook =
                getListBook.where((el) => el.id != book.id).toList();

            emit(state.copyWith(
                stateBooks:
                    state.stateBooks.copyWith(data: [book, ...listBook])));
            break;
          case MessageType.DELETE:
            final listBook =
                getListBook.where((el) => el.id != book.id).toList();
            emit(state.copyWith(
                stateBooks: state.stateBooks.copyWith(data: listBook)));
            break;
          default:
            break;
        }
      },
    );
    getListBookToDatabase();
  }

  List<Book> get getListBook => state.stateBooks.data ?? [];

  void getListBookToDatabase() async {
    try {
      emit(state.copyWith(
          stateBooks: const StateRes(status: StatusType.loading)));
      final books = await databaseService.getListBook(state.type);
      emit(state.copyWith(
          stateBooks: StateRes(status: StatusType.loaded, data: books)));
      _logger.error("books : ${books.length}", name: "getListBookToDatabase");
    } catch (err) {
      _logger.error(err, name: "getListBookToDatabase");
      emit(state.copyWith(
          stateBooks: const StateRes(
              status: StatusType.error, message: "Get list book err")));
    }
  }

  Future<void> onDeleteBook(Book book) async {
    await databaseService.deleteBook(book);
  }

  Future<Book?> getBookById(int id) => databaseService.getBookById(id);

  void onChangeType(ExtensionType type) {
    emit(state.copyWith(type: type));
    getListBookToDatabase();
  }

  @override
  Future<void> close() {
    _bookStreamSubscription.cancel();
    return super.close();
  }
}
