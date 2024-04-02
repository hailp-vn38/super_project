part of '../view/read_novel_view.dart';

class BaseMenu extends StatelessWidget {
  const BaseMenu({super.key, required this.readNovelCubit});
  final ReadNovelCubit readNovelCubit;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    final colorScheme = context.colorScheme;
    final colorBackground = colorScheme.primaryContainer.withOpacity(0.9);
    return Stack(
      children: [
        Positioned(
            left: 0,
            right: 0,
            top: 0,
            // height: kToolbarHeight + 50,
            child: AnimatedBuilder(
                animation: readNovelCubit.getAnimationController!,
                builder: (context, child) => SlideTransition(
                      position: Tween<Offset>(
                              begin: const Offset(0, -1), end: Offset.zero)
                          .animate(CurvedAnimation(
                              parent: readNovelCubit.getAnimationController!,
                              curve: Curves.easeOutQuad)),
                      child: child,
                    ),
                child: ColoredBox(
                  color: colorBackground,
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.arrow_back)),
                            Expanded(
                                child: Text(
                              readNovelCubit.getBook.name ?? "",
                              style: textTheme.titleMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ))
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, bottom: 4),
                          child: TextScroll(
                            readNovelCubit.getBook.url ?? "",
                            mode: TextScrollMode.endless,
                            velocity:
                                const Velocity(pixelsPerSecond: Offset(80, 0)),
                            delayBefore: const Duration(seconds: 1),
                            // numberOfReps: 5,
                            pauseBetween: const Duration(seconds: 2),
                            style: textTheme.labelSmall,
                            textAlign: TextAlign.right,
                            selectable: true,
                          ),
                        )
                      ],
                    ),
                  ),
                ))),
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedBuilder(
              animation: readNovelCubit.getAnimationController!,
              builder: (context, child) => SlideTransition(
                position:
                    Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                        .animate(CurvedAnimation(
                            parent: readNovelCubit.getAnimationController!,
                            curve: Curves.easeOutQuad)),
                child: child,
              ),
              child: Container(
                // height: 120,
                color: colorBackground,
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    Gaps.hGap12,
                    Align(
                      alignment: Alignment.center,
                      child: BlocSelector<ReaderCubit, ReaderState,
                          StateRes<Chapter>>(
                        selector: (state) {
                          return state.readCurrentChapter;
                        },
                        builder: (context, state) {
                          if (state.data == null) return const SizedBox();
                          return Text(state.data!.name ?? "");
                        },
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: readNovelCubit.perChapter,
                            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                        Expanded(child: SizedBox()),
                        IconButton(
                            onPressed: readNovelCubit.nextChapter,
                            icon: const Icon(Icons.arrow_forward_ios_rounded))
                      ],
                    ),
                    Gaps.hGap16,
                    Row(
                      children: [
                        Expanded(
                            child: IconButton(
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                  readNovelCubit.hideMenu();
                                },
                                icon: const Icon(Icons.menu_rounded))),
                        Expanded(
                            child: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.multiple_stop_sharp))),
                        Expanded(
                            child: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.settings_rounded))),
                      ],
                    ),
                    Gaps.hGap16,
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
