part of '../view/read_comic_view.dart';

class ComicButton extends StatelessWidget {
  const ComicButton(
      {super.key,
      this.colorBackground,
      required this.onTap,
      required this.icon,
      this.size = const Size(30, 30)});
  final Color? colorBackground;
  final VoidCallback onTap;
  final Icon icon;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: size.height,
          width: size.width,
          decoration: ShapeDecoration(
              shape: const StadiumBorder(),
              color: colorBackground ?? Colors.black87.withOpacity(0.7)),
          child: icon,
        ),
      ),
    );
  }
}
