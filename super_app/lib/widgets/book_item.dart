import 'package:flutter/material.dart';
import 'package:super_app/app/constants/dimens.dart';
import 'package:super_app/app/extensions/context_extension.dart';
import 'package:super_app/app/extensions/string_extension.dart';
import 'package:super_app/app/types.dart';
import 'package:super_app/models/models.dart';

import 'image_widget.dart';

class BookItem extends StatelessWidget {
  const BookItem(
      {super.key,
      required this.book,
      required this.onTap,
      required this.onLongTap,
      this.showType = false,
      this.showTrack = false,
      this.showDescription = true});
  final Book book;
  final ValueChanged<Book> onTap;
  final ValueChanged<Book> onLongTap;
  final bool showType;
  final bool showTrack;
  final bool showDescription;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.appTextTheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onTap(book),
        onLongPress: () => onLongTap(book),
        child: Card(
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              AspectRatio(
                aspectRatio: Dimens.coverBookAspectRatio,
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: ImageWidget(
                      image: book.cover,
                    )),
                    if (showType)
                      Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            decoration: BoxDecoration(
                                color: colorScheme.primary,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(4),
                                )),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            child: Text(
                              book.type?.title ?? "",
                              style: textTheme.bodySmall
                                  ?.copyWith(color: Colors.white, fontSize: 10),
                            ),
                          )),
                    if (showTrack)
                      Positioned(
                          left: 0,
                          bottom: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(4),
                                )),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            child: Text(
                              "${book.trackRead.value?.indexChapter != null ? "${book.trackRead.value!.indexChapter! + 1}" : "--"}/${book.trackRead.value!.totalChapter}",
                              style: textTheme.bodySmall
                                  ?.copyWith(color: Colors.white, fontSize: 10),
                            ),
                          ))
                  ],
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      (book.name ?? "").toTitleCase,
                      style: textTheme.labelMedium?.copyWith(height: 1.2),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    if (showDescription)
                      Text(
                        book.description ?? "",
                        style: textTheme.bodySmall?.copyWith(fontSize: 9),
                        maxLines: 1,
                      )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
