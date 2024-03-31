part of '../view/read_comic_view.dart';

class ListImage extends StatefulWidget {
  const ListImage(
      {super.key,
      required this.images,
      required this.headers,
      required this.initialScrollIndex,
      required this.onChangeIndexImage,
      required this.onChangeOff});
  final List<String> images;
  final int initialScrollIndex;
  final Map<String, String> headers;
  final ValueChanged<int> onChangeIndexImage;
  final void Function(double offset, double maxScroll) onChangeOff;

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
  double _maxScrollExtent = 0;

  AutoScrollController _controller = AutoScrollController();

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
    _scrollOffsetListener.changes.listen((event) {
      // widget.onChangeOff(
      //     _itemPositionsListener.itemPositions.value.last.index.toDouble(),
      //     _maxScrollExtent);
      print(event);
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.scrollToIndex(7, preferPosition: AutoScrollPosition.begin);

      // _itemScrollController.scrollTo(
      //     index: 10, duration: Duration(seconds: 15));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (Notification notification) {
        // if (notification is ScrollMetricsNotification) {
        //   if (_maxScrollExtent != notification.metrics.maxScrollExtent) {
        //     _maxScrollExtent = notification.metrics.maxScrollExtent;
        //   }
        // } else if (notification is ScrollUpdateNotification) {
        //   print(notification.dragDetails!.primaryDelta);
        // }

        return false;
      },
      child: ListView(
        controller: _controller,
        // itemCount: widget.images.length,
        // itemBuilder: (context, index) {
        //   final url = widget.images[index];
        //   return AutoScrollTag(
        //     key: ValueKey(index),
        //     controller: _controller,
        //     index: index,
        //     child: ImageWidget(
        //       image: url,
        //       httpHeaders: widget.headers,
        //       loading: true,
        //     ),
        //   );
        // },
        children: widget.images.asMap().entries.map((e) {
          final url = e;
          return AutoScrollTag(
            key: ValueKey(e.key),
            controller: _controller,
            index: e.key,
            child: ImageWidget(
              image: e.value,
              httpHeaders: widget.headers,
              loading: true,
            ),
          );
        }).toList(),
      ),
      // child: ScrollablePositionedList.builder(
      //   itemCount: widget.images.length,
      //   initialScrollIndex: widget.initialScrollIndex,
      //   itemBuilder: (context, index) {
      //     final url = widget.images[index];
      //     return ImageWidget(
      //       image: url,
      //       httpHeaders: widget.headers,
      //       loading: true,
      //     );
      //   },
      //   itemScrollController: _itemScrollController,
      //   scrollOffsetController: _scrollOffsetController,
      //   itemPositionsListener: _itemPositionsListener,
      //   scrollOffsetListener: _scrollOffsetListener,
      // ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
