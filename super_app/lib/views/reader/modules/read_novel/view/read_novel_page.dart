part of 'read_novel_view.dart';

class ReadNovelPage extends StatefulWidget {
  const ReadNovelPage({super.key});

  @override
  State<ReadNovelPage> createState() => _ReadNovelPageState();
}

class _ReadNovelPageState extends State<ReadNovelPage>
    with SingleTickerProviderStateMixin {
  late ReadNovelCubit _readNovelCubit;
  @override
  void initState() {
    _readNovelCubit = context.read<ReadNovelCubit>();
    _readNovelCubit.setAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SelectionArea(
              child: GestureDetector(
                onTap: _readNovelCubit.onTapScreen,
                onPanCancel: () {
                  _readNovelCubit.onTouchScreen();
                },
                child: BlocConsumer<ReaderCubit, ReaderState>(
                  listener: (context, state) {
                    if (state.readCurrentChapter.status == StatusType.loaded) {
                      // itemScrollController.jumpTo(index: 5);
                    }
                  },
                  buildWhen: (previous, current) =>
                      previous.readCurrentChapter != current.readCurrentChapter,
                  builder: (context, readerState) {
                    return switch (readerState.readCurrentChapter.status) {
                      StatusType.loaded => DefaultTextStyle(
                          style: textTheme.bodyMedium!
                              .copyWith(fontSize: 18, fontFamily: "Lora"),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(_readNovelCubit.removeTrashContent(
                                readerState.readCurrentChapter.data!.novel!)),
                          ),
                        ),
                      _ => const LoadingWidget()
                    };
                  },
                ),
              ),
            ),
          ),
          BlocSelector<ReadNovelCubit, ReadNovelState, MenuType>(
            selector: (state) {
              return state.menu;
            },
            builder: (context, menu) {
              print(menu);
              return switch (menu) {
                MenuType.base => BaseMenu(
                    readNovelCubit: _readNovelCubit,
                  ),
                MenuType.media => SizedBox(),
              };
            },
          )
        ],
      ),
    );
  }
}
