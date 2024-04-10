part of '../view/read_comic_view.dart';

class AutoScrollMenu extends StatelessWidget {
  const AutoScrollMenu({super.key, required this.readComicCubit});
  final ReadComicCubit readComicCubit;

  @override
  Widget build(BuildContext context) {
    final colorBackground = context.colorScheme.primaryContainer;
    return Stack(
      children: [
        Align(
            alignment: Alignment.centerRight,
            child: AnimatedBuilder(
                animation: readComicCubit.getAnimationController!,
                builder: (context, child) => SlideTransition(
                      position: Tween<Offset>(
                              begin: const Offset(1, 0), end: Offset.zero)
                          .animate(CurvedAnimation(
                              parent: readComicCubit.getAnimationController!,
                              curve: Curves.easeOutQuad)),
                      child: child,
                    ),
                child: Container(
                  margin: const EdgeInsets.only(right: 24),
                  width: 30,
                  height: context.height * 0.7,
                  child: Column(
                    children: [
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                            color: colorBackground,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20),
                                bottom: Radius.circular(20))),
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: ValueListenableBuilder(
                              valueListenable: readComicCubit
                                  .listScrollController.durationAutoScroll,
                              builder: (context, value, child) {
                                return Slider(
                                  min: 0.0,
                                  max: 200,
                                  value: value.toDouble(),
                                  onChanged: (value) {
                                    readComicCubit.listScrollController
                                        .setDurationAutoScroll(value.toInt());
                                  },
                                );
                              }),
                        ),
                      )),
                      Gaps.hGap12,
                      ValueListenableBuilder(
                        valueListenable: readComicCubit
                            .listScrollController.autoScrollStatus,
                        builder: (context, value, child) {
                          return ComicButton(
                              colorBackground: colorBackground,
                              onTap: () {
                                if (value == AutoScrollStatus.play) {
                                  readComicCubit.listScrollController
                                      .pauseAutoScroll();
                                } else {
                                  readComicCubit.listScrollController
                                      .unpauseAutoScroll();
                                }
                              },
                              icon: Icon(
                                value == AutoScrollStatus.play
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                color: Colors.white,
                              ));
                        },
                      ),
                      Gaps.hGap12,
                      ComicButton(
                          colorBackground: colorBackground,
                          onTap: () {
                            readComicCubit.closeAutoScroll();
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 20,
                          )),
                    ],
                  ),
                )))
      ],
    );
  }
}
