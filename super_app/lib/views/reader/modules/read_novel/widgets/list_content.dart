part of '../view/read_novel_view.dart';

class ListContent extends StatefulWidget {
  const ListContent({super.key, required this.content});
  final String content;

  @override
  State<ListContent> createState() => _ListContentState();
}

class _ListContentState extends State<ListContent> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  List<String> contents = [];
  @override
  void initState() {
    contents = widget.content.split("/n");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      itemScrollController.scrollListener((notification) {
        print(notification.position.pixels);
      });
      // itemScrollController.
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      itemCount: contents.length,
      itemBuilder: (context, index) => Text(contents[index]),
      itemScrollController: itemScrollController,
      itemPositionsListener: itemPositionsListener,
    );
  }
}
