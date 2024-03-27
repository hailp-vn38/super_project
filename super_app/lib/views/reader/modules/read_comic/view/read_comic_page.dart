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
      appBar: AppBar(centerTitle: true, title: const Text("Read comic")),
      body: BlocBuilder<ReaderCubit, ReaderState>(
        buildWhen: (previous, current) =>
            previous.readCurrentChapter != current.readCurrentChapter,
        builder: (context, readerState) {
          return switch (readerState.readCurrentChapter.status) {
            StatusType.loaded =>
              _buildImages(readerState.readCurrentChapter.data!),
            _ => LoadingWidget()
          };
        },
      ),
    );
  }

  Widget _buildImages(Chapter chapter) {
    return ScrollablePositionedList.builder(
      itemCount: chapter.comic!.length,
      itemBuilder: (context, index) {
        return CachedNetworkImage(
          imageUrl: chapter.comic![index],
          httpHeaders: {"Referer": chapter.url ?? ""},
        );
      },
      itemScrollController: itemScrollController,
      scrollOffsetController: scrollOffsetController,
      itemPositionsListener: itemPositionsListener,
      scrollOffsetListener: scrollOffsetListener,
    );
  }
}
