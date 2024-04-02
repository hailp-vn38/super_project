// ignore_for_file: library_private_types_in_public_api

part of '../view/read_comic_view.dart';

class ListComicImageController {
  _ListComicImageState? _state;

  ValueChanged<int>? onChangeIndex;

  ValueNotifier<int> scrollIndex = ValueNotifier(0);

  int get getCurrentIndex => scrollIndex.value;
  void _bind(_ListComicImageState? state) {
    _state = state;
  }

  void jumpTo(int index) {
    _state?._jumpTo(index);
    scrollIndex.value = index;
  }

  set setScrollIndex(int index) => scrollIndex.value = index;

  void _onChangeIndex(int index) {
    onChangeIndex?.call(index);
    scrollIndex.value = index;
  }

  void onSliderChangeValue(int index) {
    if (index == scrollIndex.value) return;
    jumpTo(index);
  }

  void enableAutoScroll() {
    _state?._enableAutoScroll(const Duration(seconds: 40));
  }
}

class ListComicImage extends StatefulWidget {
  const ListComicImage({
    super.key,
    required this.controller,
    required this.images,
    required this.headers,
    required this.initialScrollIndex,
  });
  final ListComicImageController controller;

  final List<String> images;
  final int initialScrollIndex;
  final Map<String, String> headers;

  @override
  State<ListComicImage> createState() => _ListComicImageState();
}

class _ListComicImageState extends State<ListComicImage> {
  // final ItemScrollController _itemScrollController = ItemScrollController();
  // final ScrollOffsetController _scrollOffsetController =
  //     ScrollOffsetController();
  // final ItemPositionsListener _itemPositionsListener =
  //     ItemPositionsListener.create();
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  int _currentIndex = 0;

  @override
  void initState() {
    widget.controller._bind(this);
    _itemPositionsListener.itemPositions.addListener(() {
      if (_itemPositionsListener.itemPositions.value.isEmpty) return;
      final index = _itemPositionsListener.itemPositions.value.last.index;
      if (_currentIndex != index) {
        _currentIndex = index;
        widget.controller._onChangeIndex(_currentIndex);
      }
    });
    super.initState();
  }

  void _jumpTo(int index) {
    _itemScrollController.jumpTo(index: index);
  }

  void _enableAutoScroll(Duration duration) {
    _itemScrollController.scrollToMax(duration: duration);
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      itemCount: widget.images.length,
      initialScrollIndex: widget.initialScrollIndex,
      itemBuilder: (context, index) {
        final url = widget.images[index];
        return KeepAliveWidget(
            key: ValueKey(index),
            child: ImageWidget(
              image: url,
              httpHeaders: widget.headers,
              loading: true,
            ));
      },
      itemScrollController: _itemScrollController,
      // scrollOffsetController: _scrollOffsetController,
      itemPositionsListener: _itemPositionsListener,
    );
  }
}

class ListScrollController {
  _ListScrollState? _state;

  ValueChanged<double>? onChangeOffset;

  void _bing(_ListScrollState state) {
    _state = state;
  }
}

class ListScroll extends StatefulWidget {
  const ListScroll(
      {super.key,
      required this.controller,
      required this.initialScrollOffset,
      required this.children});
  final ListScrollController controller;
  final double? initialScrollOffset;
  final List<Widget> children;

  @override
  State<ListScroll> createState() => _ListScrollState();
}

class _ListScrollState extends State<ListScroll> {
  late ScrollController _scrollController;
  late ListScrollController _controller;

  @override
  void initState() {
    _controller = widget.controller;
    _controller._bing(this);
    _scrollController = ScrollController(
        initialScrollOffset: widget.initialScrollOffset ?? 0.0);
    _scrollController.addListener(() {
      _controller.onChangeOffset?.call(_scrollController.offset);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _scrollController,
      children: widget.children,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
