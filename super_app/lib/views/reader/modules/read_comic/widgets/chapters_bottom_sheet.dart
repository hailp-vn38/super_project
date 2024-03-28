part of '../view/read_comic_view.dart';

class ChaptersBottomSheet extends StatefulWidget {
  const ChaptersBottomSheet({super.key, required this.onChangeChapter});
  final ValueChanged<Chapter> onChangeChapter;

  @override
  State<ChaptersBottomSheet> createState() => _ChaptersBottomSheetState();
}

class _ChaptersBottomSheetState extends State<ChaptersBottomSheet> {
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
    return Drawer(
      width: 280,
      child: ColoredBox(
          color: Colors.transparent,
          child: Column(
            children: [
              Container(height: 100, color: Colors.red),
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
                  return GestureDetector(
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
                  );
                },
              ))
            ],
          )),
    );
  }
}
