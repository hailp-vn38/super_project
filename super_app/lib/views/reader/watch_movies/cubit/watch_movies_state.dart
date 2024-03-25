// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'watch_movies_cubit.dart';

class WatchMoviesState extends Equatable {
  const WatchMoviesState({required this.currentWatch, this.movie});

  final StateRes<Chapter> currentWatch;
  final Movie? movie;
  @override
  List<Object?> get props => [currentWatch, movie];

  WatchMoviesState copyWith({StateRes<Chapter>? currentWatch, Movie? movie}) {
    return WatchMoviesState(
        currentWatch: currentWatch ?? this.currentWatch,
        movie: movie ?? this.movie);
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
