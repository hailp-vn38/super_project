part of '../view/read_comic_view.dart';

class ChaptersDrawer extends StatefulWidget {
  const ChaptersDrawer({super.key, required this.onChangeChapter});
  final ValueChanged<Chapter> onChangeChapter;

  @override
  State<ChaptersDrawer> createState() => _ChaptersDrawerState();
}

class _ChaptersDrawerState extends State<ChaptersDrawer> {
  late ReadComicCubit _readComicCubit;

  @override
  void initState() {
    _readComicCubit = context.read<ReadComicCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    final colorScheme = context.colorScheme;
    final book = _readComicCubit.getBook;
    return Drawer(
      width: 280,
      child: ColoredBox(
          color: Colors.transparent,
          child: Column(
            children: [
              SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        bottom: 1,
                        right: 0,
                        left: 0,
                        child: ImageWidget(image: book.cover),
                      ),
                      Positioned.fill(
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9.0),
                            child: const SizedBox(),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        top: 24,
                        bottom: 12,
                        left: 12,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AspectRatio(
                              aspectRatio: 2 / 3,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: ImageWidget(
                                  image: book.cover,
                                ),
                              ),
                            ),
                            Gaps.wGap8,
                            Text(
                              book.name ?? "",
                              style: textTheme.titleMedium,
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
              ListTile(
                title: const Text("Danh sách chương "),
                trailing: IconButton(
                  icon: const Icon(Icons.refresh_rounded),
                  onPressed: () {},
                ),
              ),
              Expanded(
                  child: ScrollablePositionedList.separated(
                itemCount: _readComicCubit.getChapters.length,
                initialScrollIndex:
                    _readComicCubit.readerCubit.getCurrentChapter.index ?? 0,
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  endIndent: 12,
                  indent: 12,
                ),
                itemBuilder: (context, index) {
                  final chapter = _readComicCubit.getChapters[index];
                  final isCurrent =
                      _readComicCubit.readerCubit.getCurrentChapter.index ==
                          index;
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        widget.onChangeChapter(chapter);
                        Scaffold.of(context).closeDrawer();
                      },
                      child: Container(
                        width: double.infinity,
                        color: isCurrent ? colorScheme.primaryContainer : null,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Text(
                          chapter.name ?? index.toString(),
                          style: textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  );
                },
              ))
            ],
          )),
    );
  }
}
