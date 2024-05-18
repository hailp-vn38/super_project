// ignore_for_file: unused_element

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:super_app/app/extensions/context_extension.dart';
import 'package:super_app/app/extensions/string_extension.dart';
import 'package:super_app/di/components/service_locator.dart';
import 'package:super_app/models/models.dart';
import 'package:super_app/services/database_service.dart';

import '../app/constants/gaps.dart';
import 'image_widget.dart';

class GirdBooks extends StatelessWidget {
  const GirdBooks(
      {super.key,
      required this.data,
      this.childAspectRatio = 2 / 3.62,
      required this.onTap,
      required this.onLongTap,
      this.isLibrary = false});
  final List<Book> data;
  final double childAspectRatio;
  final bool isLibrary;
  final ValueChanged<Book>? onTap;
  final ValueChanged<Book>? onLongTap;
  // final Stream<void>?  watchTrackById();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: getCrossAxisCount(context),
          crossAxisSpacing: 8,
          childAspectRatio: childAspectRatio,
          mainAxisSpacing: 8),
      itemBuilder: (context, index) {
        final book = data[index];
        return _BookItem(
          key: ValueKey(book.id ?? book.name),
          index: index,
          isLibrary: isLibrary,
          book: book,
          onTap: (value) => onTap?.call(value),
          onLongTap: (value) => onLongTap?.call(value),
        );
      },
    );
  }

  int getCrossAxisCount(BuildContext context) {
    final width = context.width;
    if (Platform.isAndroid || Platform.isIOS) {
      return width ~/ 120;
    }
    return width ~/ 150;
  }
}

class _BookItem extends StatefulWidget {
  const _BookItem(
      {super.key,
      required this.book,
      required this.onTap,
      required this.onLongTap,
      required this.isLibrary,
      required this.index});
  final Book book;
  final ValueChanged<Book> onTap;
  final ValueChanged<Book> onLongTap;
  final bool isLibrary;
  final int index;

  @override
  State<_BookItem> createState() => _BookItemState();
}

class _BookItemState extends State<_BookItem> {
  StreamSubscription? _streamSubscription;
  late DatabaseService _databaseService;
  late Book _book;
  @override
  void initState() {
    _databaseService = getIt<DatabaseService>();
    _book = widget.book;
    if (widget.index == 0) {
      _streamSubscription = _databaseService
          .watchTrackById(widget.book.trackRead.value!.id!)
          .listen((event) async {
        _tmp();
      });
    }

    super.initState();
  }

  void _tmp() async {
    final book = await _databaseService.getBookById(widget.book.id!);
    if (book != null) {
      setState(() {
        _book = book;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final read = _book.trackRead.value!;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => widget.onTap(_book),
        onLongPress: () => widget.onLongTap(_book),
        child: Card(
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              AspectRatio(
                aspectRatio: 2 / 2.7,
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: ImageWidget(
                      image: _book.cover!,
                    )),
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
                            "${read.indexChapter != null ? "${read.indexChapter! + 1}" : "--"}C - ${read.percent ?? 0}%",
                            style: context.appTextTheme.bodySmall
                                ?.copyWith(color: Colors.white, fontSize: 10),
                          ),
                        ))
                  ],
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  children: [
                    Gaps.hGap4,
                    Expanded(
                      child: Text(
                        _book.name!.toTitleCase,
                        style: context.appTextTheme.labelMedium
                            ?.copyWith(height: 1.2),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Text(
                    //   _book.chapters.length.toString(),
                    //   style: context.appTextTheme.bodySmall
                    //       ?.copyWith(height: 1, fontSize: 11),
                    //   textAlign: TextAlign.center,
                    //   maxLines: 1,
                    //   overflow: TextOverflow.visible,
                    // ),
                    const SizedBox(
                      height: 4,
                    ),
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}
