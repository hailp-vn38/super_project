part of '../view/watch_movies_view.dart';

class LoadingMovie extends StatelessWidget {
  const LoadingMovie({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Colors.black,
      child: SpinKitFadingCircle(
        color: Colors.grey,
      ),
    );
  }
}
