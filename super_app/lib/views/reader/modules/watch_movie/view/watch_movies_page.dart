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
    final textTheme = context.appTextTheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleTextStyle: textTheme.titleMedium,
        title: Text(_watchMoviesCubit.getBook.name!),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, RoutesName.detail,
                    arguments: _watchMoviesCubit.getBook.url?.replaceUrl(
                        _watchMoviesCubit.readerCubit.args.extension!.source));
              },
              icon: const Icon(Icons.info_rounded))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: BlocListener<WatchMoviesCubit, WatchMoviesState>(
                  listener: (context, state) {
                    // if (state.movie != null && Platform.isMacOS ||
                    //     Platform.isWindows) {
                    //   _watchMoviesCubit.onWatchWebView();
                    // }
                  },
                  child: BlocConsumer<ReaderCubit, ReaderState>(
                    listener: (context, state) {
                      if (state.readCurrentChapter.status == StatusType.error) {
                        DialogUtils.showAlertDialog(context,
                            title: state.readCurrentChapter.data?.name,
                            content: state.readCurrentChapter.message);
                      }
                      switch (state.readCurrentChapter.status) {
                        case StatusType.error:
                          break;
                        case StatusType.loaded:
                          _watchMoviesCubit
                              .onSetMovie(state.readCurrentChapter.data!);
                          break;
                        default:
                          break;
                      }
                    },
                    buildWhen: (previous, current) =>
                        previous.readCurrentChapter !=
                        current.readCurrentChapter,
                    builder: (context, state) {
                      final current = state.readCurrentChapter;
                      return switch (current.status) {
                        StatusType.loaded => BlocSelector<WatchMoviesCubit,
                              WatchMoviesState, Movie?>(
                            selector: (state) => state.movie,
                            builder: (context, movie) {
                              if (movie == null) {
                                return LoadErrMovie(
                                  onTap: () {
                                    _watchMoviesCubit
                                        .onChangeChapter(current.data!);
                                  },
                                );
                              }

                              if ((Platform.isMacOS || Platform.isWindows) &&
                                  movie.type != MovieType.file) {
                                return MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () {
                                      _watchMoviesCubit.onWatchWebView();
                                    },
                                    child: const ColoredBox(
                                      color: Colors.black,
                                      child: Center(
                                        child: Icon(
                                          Icons.play_arrow,
                                          size: 50,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return switch (movie.type) {
                                MovieType.file => PlayMedia(
                                    url: movie.data,
                                    httpHeaders:
                                        _watchMoviesCubit.httpHeaders(),
                                  ),
                                _ => PlayMovieWebView(
                                    key: ValueKey(
                                        "${current.data!.name}_${movie.serverName}"),
                                    url: movie.data,
                                    onTapWatch: () {
                                      // _watchMoviesCubit.onWatchWebView();
                                      final snackBar = SnackBar(
                                        content:
                                            const Text('Hi, I am a SnackBar!'),
                                        backgroundColor: (Colors.black12),
                                        action: SnackBarAction(
                                          label: 'dismiss',
                                          onPressed: () {},
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    },
                                  )
                              };
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
              BlocSelector<ReaderCubit, ReaderState, Chapter?>(
                selector: (state) {
                  return state.readCurrentChapter.data;
                },
                builder: (context, currentChapter) {
                  if (currentChapter == null) return const SizedBox();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        // child: Text(
                        //   "Đang xem : ${currentChapter.name}",
                        //   style: context.appTextTheme.titleMedium,
                        // ),
                        child: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: "Đang xem : ",
                              style: context.appTextTheme.bodyMedium),
                          TextSpan(
                              text: "${currentChapter.name}",
                              style: context.appTextTheme.titleMedium),
                        ])),
                      ),
                      BlocSelector<WatchMoviesCubit, WatchMoviesState, Movie?>(
                        selector: (state) {
                          return state.movie;
                        },
                        builder: (context, movie) {
                          if (movie == null ||
                              currentChapter.getMovies == null) {
                            return const SizedBox();
                          }
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                child: Text("Server :"),
                              ),
                              Expanded(
                                child: Wrap(
                                  children: currentChapter.getMovies!
                                      .map((item) => ServerMovieCard(
                                            movie: item,
                                            currentWatch: movie.serverName ==
                                                item.serverName,
                                            onTap: () {
                                              _watchMoviesCubit
                                                  .onChangeServer(item);
                                            },
                                          ))
                                      .toList(),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        child: Row(
                          children: [
                            Text(
                              "Danh sách tập phim",
                              style: context.appTextTheme.bodyLarge,
                            ),
                            Gaps.wGap4,
                            IconButton(
                                onPressed: () {
                                  final snackBar = SnackBar(
                                    content: const Text('Hi, I am a SnackBar!'),
                                    backgroundColor:
                                        context.colorScheme.onSurface,
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                },
                                icon: const Icon(Icons.refresh_rounded))
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: BlocBuilder<ReaderCubit, ReaderState>(
                  builder: (context, readerCubit) {
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: readerCubit.chapters
                          .map((chapter) => ChapterCard(
                                chapter: chapter,
                                currentWatch: chapter.index ==
                                    readerCubit.trackRead.indexChapter,
                                onTap: () {
                                  _watchMoviesCubit.onChangeChapter(chapter);
                                },
                              ))
                          .toList(),
                    );
                  },
                ),
              ),
              Gaps.hGap16,
            ],
          ),
        ),
      ),
    );
  }
}
