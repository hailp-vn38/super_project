part of '../view/read_novel_view.dart';

class ChaptersDrawer extends StatefulWidget {
  const ChaptersDrawer({super.key});

  @override
  State<ChaptersDrawer> createState() => _ChaptersDrawerState();
}

class _ChaptersDrawerState extends State<ChaptersDrawer> {
  late ReadNovelCubit _readNovelCubit;
  @override
  void initState() {
    _readNovelCubit = context.read<ReadNovelCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    final colorScheme = context.colorScheme;
    final book = _readNovelCubit.getBook;
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
                            Expanded(
                                child: Text(
                              book.name ?? "",
                              style: textTheme.titleMedium,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ))
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
                itemCount: _readNovelCubit.getChapters.length,
                initialScrollIndex:
                    _readNovelCubit.readerCubit.getCurrentChapter.index ?? 0,
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  endIndent: 12,
                  indent: 12,
                ),
                itemBuilder: (context, index) {
                  final chapter = _readNovelCubit.getChapters[index];
                  final isCurrent =
                      _readNovelCubit.readerCubit.getCurrentChapter.index ==
                          index;
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        _readNovelCubit.onChangeChapter(chapter);
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
