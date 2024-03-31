part of '../view/watch_movies_view.dart';

class LoadErrMovie extends StatelessWidget {
  const LoadErrMovie({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: const ColoredBox(
          color: Colors.black,
          child: Center(
            child: Icon(
              Icons.play_arrow,
              size: 40,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
