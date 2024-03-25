part of '../view/watch_movies_view.dart';

class ServerMovieCard extends StatelessWidget {
  const ServerMovieCard(
      {super.key,
      required this.movie,
      this.currentWatch = false,
      required this.onTap});
  final Movie movie;
  final bool currentWatch;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: currentWatch ? context.colorScheme.primaryContainer : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              movie.serverName ?? "",
              style: context.appTextTheme.titleSmall,
            ),
          ),
        ),
      ),
    );
  }
}
