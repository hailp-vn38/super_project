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
                ))),
      ],
    );
  }
}
