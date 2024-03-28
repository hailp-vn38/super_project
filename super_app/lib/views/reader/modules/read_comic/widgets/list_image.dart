part of '../view/read_comic_view.dart';

class ListImage extends StatefulWidget {
  const ListImage(
      {super.key,
      required this.images,
      required this.headers,
      required this.initialScrollIndex,
      required this.onChangeIndexImage});
  final List<String> images;
  final int initialScrollIndex;
  final Map<String, String> headers;
  final ValueChanged<int> onChangeIndexImage;

  @override
  State<ListImage> createState() => _ListImageState();
}

class _ListImageState extends State<ListImage> {
  late ItemScrollController _itemScrollController;
  late ScrollOffsetController _scrollOffsetController;
  late ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  late ScrollOffsetListener _scrollOffsetListener =
      ScrollOffsetListener.create();
  int _currentIndex = 0;
  @override
  void initState() {
    _itemScrollController = ItemScrollController();
    _scrollOffsetController = ScrollOffsetController();
    _itemPositionsListener = ItemPositionsListener.create();
    _scrollOffsetListener = ScrollOffsetListener.create();
    _itemPositionsListener.itemPositions.addListener(() {
      if (_itemPositionsListener.itemPositions.value.isEmpty) return;
      final index = _itemPositionsListener.itemPositions.value.last.index;
      if (_currentIndex != index) {
        _currentIndex = index;
        widget.onChangeIndexImage(_currentIndex);
      }
    });
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   _itemScrollController.scrollTo(
    //       index: 10, duration: Duration(seconds: 15));
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      itemCount: widget.images.length,
      initialScrollIndex: widget.initialScrollIndex,
      itemBuilder: (context, index) {
        final url = widget.images[index];
        return ImageWidget(
          image: url,
          httpHeaders: widget.headers,
          loading: true,
        );
      },
      itemScrollController: _itemScrollController,
      scrollOffsetController: _scrollOffsetController,
      itemPositionsListener: _itemPositionsListener,
      scrollOffsetListener: _scrollOffsetListener,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
