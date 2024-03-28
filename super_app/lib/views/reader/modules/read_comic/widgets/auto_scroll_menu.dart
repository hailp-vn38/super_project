part of '../view/read_comic_view.dart';

class AutoScrollMenu extends StatelessWidget {
  const AutoScrollMenu({super.key, required this.readComicCubit});
  final ReadComicCubit readComicCubit;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: AnimatedBuilder(
                animation: readComicCubit.getAnimationController!,
                builder: (context, child) => SlideTransition(
                      position: Tween<Offset>(
                              begin: const Offset(0, -1), end: Offset.zero)
                          .animate(CurvedAnimation(
                              parent: readComicCubit.getAnimationController!,
                              curve: Curves.easeOutQuad)),
                      child: child,
                    ),
                child: Container(
                  height: 120,
                  color: Colors.amber,
                  child: SafeArea(bottom: false, child: Text("fe")),
                )))
      ],
    );
  }
}
