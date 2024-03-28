part of 'read_comic_view.dart';

class ReadComicPage extends StatefulWidget {
  const ReadComicPage({super.key});

  @override
  State<ReadComicPage> createState() => _ReadComicPageState();
}

class _ReadComicPageState extends State<ReadComicPage>
    with SingleTickerProviderStateMixin {
  late ReadComicCubit _readComicCubit;
  @override
  void initState() {
    _readComicCubit = context.read<ReadComicCubit>();
    _readComicCubit.setAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ChaptersBottomSheet(
        onChangeChapter: (chapter) {
          _readComicCubit.onChangeChapter(chapter);
        },
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _readComicCubit.onTapScreen,
              // onPanDown: (_) => _readComicCubit.onTouchScreen(),
              onPanCancel: () {
                _readComicCubit.onTouchScreen();
              },
              child: BlocConsumer<ReaderCubit, ReaderState>(
                listener: (context, state) {
                  if (state.readCurrentChapter.status == StatusType.loaded) {
                    // itemScrollController.jumpTo(index: 5);
                  }
                },
                buildWhen: (previous, current) =>
                    previous.readCurrentChapter != current.readCurrentChapter,
                builder: (context, readerState) {
                  return switch (readerState.readCurrentChapter.status) {
                    StatusType.loaded => ListImage(
                        key: ValueKey(
                            readerState.readCurrentChapter.data!.index),
                        images: readerState.readCurrentChapter.data!.comic!,
                        headers: _readComicCubit.getHttpHeaders,
                        initialScrollIndex:
                            _readComicCubit.getInitialScrollIndex,
                        onChangeIndexImage: _readComicCubit.onChangeScrollIndex,
                      ),
                    _ => const LoadingWidget()
                  };
                },
              ),
            ),
          ),
          BlocSelector<ReadComicCubit, ReadComicState, MenuComic>(
            selector: (state) {
              return state.menu;
            },
            builder: (context, menu) {
              return switch (menu) {
                MenuComic.base => BaseMenu(readComicCubit: _readComicCubit),
                MenuComic.autoScroll =>
                  AutoScrollMenu(readComicCubit: _readComicCubit),
              };
            },
          )
        ],
      ),
    );
  }
}
