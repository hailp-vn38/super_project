// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_big_cubit.dart';

class SearchBigState extends Equatable {
  const SearchBigState(
      {required this.status,
      required this.exts,
      required this.stateRes,
      required this.stateBooks});
  final StatusType status;
  final List<Extension> exts;
  final StateRes<List<Extension>> stateRes;
  final StateRes<List<Book>> stateBooks;

  @override
  List<Object> get props => [status, exts, stateRes, stateBooks];

  SearchBigState copyWith(
      {StatusType? status,
      List<Extension>? exts,
      StateRes<List<Extension>>? stateRes,
      StateRes<List<Book>>? stateBooks}) {
    return SearchBigState(
        status: status ?? this.status,
        exts: exts ?? this.exts,
        stateRes: stateRes ?? this.stateRes,
        stateBooks: stateBooks ?? this.stateBooks);
  }
}
