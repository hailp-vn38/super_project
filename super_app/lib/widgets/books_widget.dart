import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:js_runtime/js_runtime.dart';
import 'package:super_app/app/extensions/context_extension.dart';
import 'package:super_app/models/models.dart';
import 'package:super_app/widgets/book_item.dart';

typedef OnFetchListBook = Future<List<Book>> Function(String url, int page);

class BooksWidget extends StatefulWidget {
  const BooksWidget(
      {super.key,
      required this.onFetchListBook,
      required this.url,
      this.onTap,
      this.onLongTap,
      this.initialData,
      this.isLoad = true,
      required this.showDes,
      this.showType = false,
      this.showTrack = false});
  final List<Book>? initialData;
  final OnFetchListBook? onFetchListBook;
  final ValueChanged<Book>? onTap;
  final ValueChanged<Book>? onLongTap;
  final bool isLoad;
  final String url;
  final bool showDes;
  final bool showType;
  final bool showTrack;

  @override
  State<BooksWidget> createState() => _BooksWidgetState();
}

class _BooksWidgetState extends State<BooksWidget> {
  int _page = 1;
  final List<Book> _listBook = [];
  bool _isLoading = false;

  bool _isLoadMore = false;

  late final ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController();
    if (widget.isLoad) {
      _scrollController.addListener(() {
        if ((_scrollController.offset >
                _scrollController.position.maxScrollExtent - 200) &&
            !_isLoadMore) {
          _onLoadMore();
        }
      });
      if (widget.initialData != null) {
        _listBook.addAll(widget.initialData!);
        _isLoading = false;
      } else {
        _onLoading();
      }
    } else {
      _listBook.addAll(widget.initialData ?? []);
    }

    super.initState();
  }

  Future<void> _onLoading() async {
    try {
      setState(() {
        _isLoading = true;
      });
      _page = 1;
      _listBook.clear();
      List<Book> books = await widget.onFetchListBook!.call(widget.url, _page);

      // if (books.isNotEmpty && books.length < 15) {
      //   _page++;
      //   final result = await widget.onFetchListBook!.call(widget.url, _page);
      //   books.addAll(result);
      // }
      _listBook.addAll(books);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      if (_listBook.isNotEmpty && _listBook.length < 15) {
        _onLoadMore();
      }
    } on JsRuntimeException {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onLoadMore() async {
    setState(() {
      _isLoadMore = true;
    });
    try {
      _page++;
      final list = await widget.onFetchListBook!.call(widget.url, _page);
      if (list.isNotEmpty) {
        setState(() {
          _listBook.addAll(list);
        });
        // widget.onChangeBooks?.call(_listBook);
      }
    } catch (error) {
      //
    }
    setState(() {
      _isLoadMore = false;
    });
  }

  Future<void> _onRefresh() async {
    try {
      _page = 1;
      final list = await widget.onFetchListBook!.call(widget.url, _page);
      _listBook.clear();
      _listBook.addAll(list);
      setState(() {});
    } catch (err) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Text("Loading"),
      );
    }
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            const SliverToBoxAdapter(
              child: SizedBox(height: 8),
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: getCrossAxisCount(),
                  crossAxisSpacing: 8,
                  childAspectRatio: 2 / 3.62,
                  mainAxisSpacing: 8),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final book = _listBook[index];
                  return BookItem(
                    key: ValueKey(book.id),
                    book: book,
                    onTap: (value) => widget.onTap?.call(value),
                    onLongTap: (value) => widget.onLongTap?.call(value),
                    showDescription: widget.showDes,
                    showTrack: widget.showTrack,
                    showType: widget.showType,
                  );
                },
                childCount: _listBook.length,
              ),
            ),
            SliverToBoxAdapter(
              child: _isLoadMore
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: SpinKitThreeBounce(
                        color: context.colorScheme.primary,
                        size: 25.0,
                      ),
                    )
                  : const SizedBox(height: 8),
            ),
          ],
        ),
      ),
    );
  }

  int getCrossAxisCount() {
    final width = context.width;
    if (Platform.isAndroid || Platform.isIOS) {
      return width ~/ 120;
    }
    return width ~/ 150;
  }

  @override
  void didUpdateWidget(covariant BooksWidget oldWidget) {
    if (widget.initialData != null &&
        widget.initialData!.length != (oldWidget.initialData ?? []).length) {
      setState(() {
        _listBook.clear();
        _listBook.addAll(widget.initialData!);
      });
    }
    super.didUpdateWidget(oldWidget);
  }
}

// class BookItem extends StatelessWidget {
//   const BookItem(
//       {super.key,
//       required this.book,
//       required this.onTap,
//       required this.onLongTap});
//   final Book book;
//   final VoidCallback onTap;
//   final VoidCallback onLongTap;

//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//       cursor: SystemMouseCursors.click,
//       child: GestureDetector(
//         onTap: onTap,
//         onLongPress: onLongTap,
//         child: Card(
//           margin: EdgeInsets.zero,
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               AspectRatio(
//                 aspectRatio: 2 / 2.7,
//                 child: ImageWidget(
//                   image: book.cover!,
//                 ),
//               ),
//               const SizedBox(
//                 height: 4,
//               ),
//               Expanded(
//                   child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 4),
//                 child: Column(
//                   children: [
//                     Gaps.hGap4,
//                     Expanded(
//                       child: Text(
//                         book.name!.toTitleCase,
//                         style: context.appTextTheme.labelMedium
//                             ?.copyWith(height: 1.2),
//                         maxLines: 2,
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     Text(
//                       book.description ?? "",
//                       style: context.appTextTheme.bodySmall
//                           ?.copyWith(height: 1, fontSize: 11),
//                       textAlign: TextAlign.center,
//                       maxLines: 1,
//                       overflow: TextOverflow.visible,
//                     ),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                   ],
//                 ),
//               ))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
