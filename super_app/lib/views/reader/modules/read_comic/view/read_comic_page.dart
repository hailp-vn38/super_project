part of 'read_comic_view.dart';

class ReadComicPage extends StatefulWidget {
  const ReadComicPage({super.key});

  @override
  State<ReadComicPage> createState() => _ReadComicPageState();
}

class _ReadComicPageState extends State<ReadComicPage> {
  late ReadComicCubit _readComicCubit;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();
  @override
  void initState() {
    _readComicCubit = context.read<ReadComicCubit>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Read comic"),
        actions: [
          IconButton(
              onPressed: () {
                // itemScrollController.jumpTo(index: 1);
                _readComicCubit.nextChapter();
              },
              icon: const Icon(Icons.ten_mp))
        ],
      ),
      body: BlocConsumer<ReaderCubit, ReaderState>(
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
                key: ValueKey(readerState.readCurrentChapter.data!.index),
                images: readerState.readCurrentChapter.data!.comic!,
                headers: _readComicCubit.getHttpHeaders,
                initialScrollIndex: _readComicCubit.getInitialScrollIndex,
                onChangeIndexImage: _readComicCubit.onChangeScrollIndex,
              ),
            _ => const LoadingWidget()
          };
        },
      ),
    );
  }
}
