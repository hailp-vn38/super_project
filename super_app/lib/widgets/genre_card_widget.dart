import 'package:flutter/material.dart';
import 'package:super_app/models/models.dart';

class GenreCard extends StatelessWidget {
  const GenreCard({super.key, required this.genre, required this.onTap});
  final Genre genre;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (genre.title == null || genre.url == null) return const SizedBox();
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          margin: const EdgeInsets.all(4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Text(genre.title!),
          ),
        ),
      ),
    );
  }
}
