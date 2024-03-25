part of 'watch_movies_view.dart';

class WatchMoviesPage extends StatefulWidget {
  const WatchMoviesPage({super.key});

  @override
  State<WatchMoviesPage> createState() => _WatchMoviesPageState();
}

class _WatchMoviesPageState extends State<WatchMoviesPage> {
  late WatchMoviesCubit _watchMoviesCubit;
  @override
  void initState() {
    _watchMoviesCubit = context.read<WatchMoviesCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: false, title: Text(_watchMoviesCubit.getBook.name!)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: BlocListener<WatchMoviesCubit, WatchMoviesState>(
                listener: (context, state) {
                  if (state.movie != null && Platform.isMacOS ||
                      Platform.isWindows) {
                    _watchMoviesCubit.onWatchWebView();
                  }
                },
                child: BlocConsumer<WatchMoviesCubit, WatchMoviesState>(
                  listener: (context, state) {
                    if (state.currentWatch.status == StatusType.error) {
                      DialogUtils.showAlertDialog(context,
                          title: state.currentWatch.data?.name,
                          content: state.currentWatch.message);
                    }
                  },
                  buildWhen: (previous, current) =>
                      previous.currentWatch != current.currentWatch,
                  builder: (context, state) {
                    final current = state.currentWatch;
                    return switch (current.status) {
                      StatusType.loaded => BlocSelector<WatchMoviesCubit,
                            WatchMoviesState, Movie?>(
                          selector: (state) => state.movie,
                          builder: (context, movie) {
                            if (movie == null) return const SizedBox();
                            return PlayMovieWebView(
                              key: ValueKey(
                                  "${current.data!.name}_${movie.serverName}"),
                              url: movie.data,
                              onTapWatch: () {
                                _watchMoviesCubit.onWatchWebView();
                              },
                            );
                          },
                        ),
                      StatusType.error => LoadErrMovie(
                          onTap: () {
                            _watchMoviesCubit.onChangeChapter(current.data!);
                          },
                        ),
                      _ => const LoadingMovie()
                    };
                  },
                ),
              ),
            ),
            BlocSelector<WatchMoviesCubit, WatchMoviesState, Chapter>(
              selector: (state) {
                return state.currentWatch.data!;
              },
              builder: (context, currentChapter) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: Text("Đang xem : ${currentChapter.name}"),
                    ),
                    BlocSelector<WatchMoviesCubit, WatchMoviesState, Movie?>(
                      selector: (state) {
                        return state.movie;
                      },
                      builder: (context, movie) {
                        if (movie == null) return const SizedBox();
                        return Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              child: Text("Server name:"),
                            ),
                            Wrap(
                              children: currentChapter.getMovies!
                                  .map((item) => ServerMovieCard(
                                        movie: item,
                                        currentWatch:
                                            movie.serverName == item.serverName,
                                        onTap: () {
                                          _watchMoviesCubit
                                              .onChangeServer(item);
                                        },
                                      ))
                                  .toList(),
                            )
                          ],
                        );
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: Text("Danh sách tập phim"),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _watchMoviesCubit.getChapters
                          .map((chapter) => ChapterCard(
                                chapter: chapter,
                                currentWatch:
                                    chapter.index == currentChapter.index,
                                onTap: () {
                                  _watchMoviesCubit.onChangeChapter(chapter);
                                },
                              ))
                          .toList(),
                    ),
                  ],
                );
              },
            ),
            Gaps.hGap16,
          ],
        ),
      ),
    );
  }
}
