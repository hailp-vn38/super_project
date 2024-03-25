// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'watch_movies_cubit.dart';

class WatchMoviesState extends Equatable {
  const WatchMoviesState({this.movie});

  final Movie? movie;
  @override
  List<Object?> get props => [movie];

  WatchMoviesState copyWith({Movie? movie}) {
    return WatchMoviesState(movie: movie ?? this.movie);
  }
}
