// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'detail_cubit.dart';

class DetailState extends Equatable {
  const DetailState(
      {required this.bookState,
      required this.chaptersState,
      required this.genresState});
  final StateRes<Book> bookState;
  final StateRes<List<Chapter>> chaptersState;
  final StateRes<List<Genre>> genresState;

  @override
  List<Object> get props => [bookState, chaptersState, genresState];

  DetailState copyWith(
      {StateRes<Book>? bookState,
      StateRes<List<Chapter>>? chaptersState,
      StateRes<List<Genre>>? genresState}) {
    return DetailState(
        bookState: bookState ?? this.bookState,
        chaptersState: chaptersState ?? this.chaptersState,
        genresState: genresState ?? this.genresState);
  }
}

class StateRes<T> extends Equatable {
  final StatusType status;
  final T? data;
  final String? message;
  const StateRes({required this.status, this.data, this.message});

  StateRes<T> copyWith({StatusType? status, T? data, String? message}) {
    return StateRes<T>(
        status: status ?? this.status,
        data: data ?? this.data,
        message: message ?? this.message);
  }

  @override
  List<Object?> get props => [status, data, message];
}
