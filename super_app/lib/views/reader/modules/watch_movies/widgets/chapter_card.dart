part of '../view/watch_movies_view.dart';

class ChapterCard extends StatelessWidget {
  const ChapterCard(
      {super.key,
      required this.chapter,
      required this.currentWatch,
      required this.onTap});
  final Chapter chapter;
  final bool currentWatch;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          margin: EdgeInsets.zero,
          color: currentWatch ? colorScheme.primaryContainer : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              chapter.name ?? "",
              style: currentWatch
                  ? context.appTextTheme.titleSmall
                  : context.appTextTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.normal),
            ),
          ),
        ),
      ),
    );
  }
}
