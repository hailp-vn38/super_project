import 'package:flutter/material.dart';
import 'package:super_app/app/extensions/context_extension.dart';

class ExtensionTag extends StatelessWidget {
  const ExtensionTag({super.key, required this.text, this.color});
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.appTextTheme;
    final tagColor = color ?? colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
          color: tagColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: tagColor,
          )),
      child: Text(
        text,
        style: textTheme.labelSmall?.copyWith(fontSize: 6),
      ),
    );
  }
}
