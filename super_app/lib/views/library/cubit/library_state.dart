// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'library_cubit.dart';

class LibraryState extends Equatable {
  const LibraryState({required this.stateBooks, required this.type});

  final StateRes<List<Book>> stateBooks;
  final ExtensionType type;

  @override
  List<Object> get props => [stateBooks, type];

  LibraryState copyWith(
      {StateRes<List<Book>>? stateBooks, ExtensionType? type}) {
    return LibraryState(
        stateBooks: stateBooks ?? this.stateBooks, type: type ?? this.type);
  }
}
