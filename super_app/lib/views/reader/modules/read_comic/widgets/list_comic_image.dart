// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: library_private_types_in_public_api

part of '../view/read_comic_view.dart';

enum AutoScrollStatus { play, pause, stop }

class ScrollPosition {
  final double offset;
  final double maxScrollExtent;
  final double height;
  const ScrollPosition({
    required this.offset,
    required this.maxScrollExtent,
    required this.height,
  });

  ScrollPosition copyWith({
    double? offset,
    double? maxScrollExtent,
    double? height,
  }) {
    return ScrollPosition(
      offset: offset ?? this.offset,
      maxScrollExtent: maxScrollExtent ?? this.maxScrollExtent,
      height: height ?? this.height,
    );
  }

  @override
  String toString() =>
      'ScrollPosition(offset: $offset, maxScrollExtent: $maxScrollExtent, height: $height)';
}

class ListScrollController {
  final int defaultDurationAutoScroll;

  ListScrollController({required this.defaultDurationAutoScroll}) {
    durationAutoScroll = ValueNotifier(defaultDurationAutoScroll);
  }
  // final _logger = Logger("ListScrollController");

  _ListScrollState? _state;

  ValueChanged<({double offset, double maxScrollExtent, double height})>?
      onScroll;
  VoidCallback? onScrollMax;

  late ValueNotifier<int> durationAutoScroll;

  ValueNotifier<AutoScrollStatus> autoScrollStatus =
      ValueNotifier(AutoScrollStatus.stop);

  ValueNotifier<ScrollPosition> scrollPosition = ValueNotifier(
      const ScrollPosition(height: 0.0, maxScrollExtent: 0.0, offset: 0.0));

  bool isAutoScroll = false;

  void _bing(_ListScrollState state) {
    _state = state;
  }

  void _addListener() {
    _state?._scrollController.addListener(() {
      final maxScroll = _state!._scrollController.position.maxScrollExtent;
      final offset = _state!._scrollController.offset;
      scrollPosition.value = ScrollPosition(
          offset: offset,
          maxScrollExtent: _state!._scrollController.position.maxScrollExtent,
          height: _state!.context.height);
      if (scrollPosition.value.maxScrollExtent != maxScroll) {
        scrollPosition.value =
            scrollPosition.value.copyWith(maxScrollExtent: maxScroll);
        if (isAutoScroll) {
          updateAutoScroll();
        }
      }
      if (isAutoScroll && offset == maxScroll) {
        onScrollMax?.call();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollPosition.value = scrollPosition.value.copyWith(
          offset: _state?._scrollController.initialScrollOffset,
          maxScrollExtent: _state?._scrollController.position.maxScrollExtent,
          height: _state?.context.height);
      if (isAutoScroll) {
        Future.delayed(const Duration(seconds: 2)).then((value) {
          updateAutoScroll();
        });
      }
    });
  }

  void enableAutoScroll() {
    isAutoScroll = true;
    _state?._autoScroll(Duration(seconds: durationAutoScroll.value));
    _state?._setState();
    autoScrollStatus.value = AutoScrollStatus.play;
  }

  void stopAutoScroll() {
    isAutoScroll = false;
    _state?._stopScroll();
    _state?._setState();
    autoScrollStatus.value = AutoScrollStatus.stop;
  }

  void jumpToScroll(double value) {
    _state?._jumpTo(value);
  }

  void setDurationAutoScroll(int value) {
    durationAutoScroll.value = value;
    _state?._autoScroll(Duration(seconds: value));
  }

  void updateAutoScroll() {
    if (!isAutoScroll) return;
    _state?._autoScroll(Duration(seconds: durationAutoScroll.value));
  }

  void _updateHeight() {
    scrollPosition.value =
        scrollPosition.value.copyWith(height: _state?.context.height);
  }

  void pauseAutoScroll() {
    _state?._stopScroll();
    autoScrollStatus.value = AutoScrollStatus.pause;
    isAutoScroll = false;
    _state?._setState();
  }

  void unpauseAutoScroll() {
    enableAutoScroll();
  }

  void dispose() {
    durationAutoScroll.dispose();
  }
}

class ListScroll extends StatefulWidget {
  const ListScroll(
      {super.key,
      required this.controller,
      this.initialScrollOffset,
      required this.children});
  final ListScrollController controller;
  final double? initialScrollOffset;
  final List<Widget> children;

  @override
  State<ListScroll> createState() => _ListScrollState();
}

class _ListScrollState extends State<ListScroll> with WidgetsBindingObserver {
  late ScrollController _scrollController;
  late ListScrollController _controller;

  @override
  void initState() {
    _controller = widget.controller;
    _controller._bing(this);
    _scrollController = ScrollController(
        initialScrollOffset: widget.initialScrollOffset ?? 0.0);
    print("init ${widget.initialScrollOffset}");
    _controller._addListener();

    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  void _stopScroll() {
    _scrollController.position.hold(() {});
  }

  void _autoScroll(Duration duration) {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: duration, curve: Curves.linear);
  }

  void _setState() {
    setState(() {});
  }

  void _jumpTo(double value) {
    _scrollController.jumpTo(value);
  }

  @override
  void didChangeMetrics() {
    if (_controller.scrollPosition.value.height != context.height) {
      _controller.updateAutoScroll();
      _controller._updateHeight();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        height: constraints.maxHeight,
        width: constraints.maxWidth,
        child: SingleChildScrollView(
          physics: _controller.isAutoScroll
              ? const NeverScrollableScrollPhysics()
              : null,
          controller: _scrollController,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: widget.children,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
