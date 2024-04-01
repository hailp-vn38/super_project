part of '../view/read_novel_view.dart';

class BaseMenu extends StatelessWidget {
  const BaseMenu({super.key, required this.readNovelCubit});
  final ReadNovelCubit readNovelCubit;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    final colorScheme = context.colorScheme;
    final colorBackground = colorScheme.primaryContainer;
    return Stack(
      children: [
        Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: kToolbarHeight + 50,
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
                child: AppBar(
                  title: Text(
                    readNovelCubit.getBook.name ?? "",
                    style: textTheme.titleMedium,
                  ),
                  bottom: PreferredSize(
                      preferredSize: Size(context.width, 50),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
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
                      )),
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
                height: 120,
                color: Colors.amber,
              ),
            )),
      ],
    );
  }


}
