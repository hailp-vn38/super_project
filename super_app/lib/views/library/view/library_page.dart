// ignore_for_file: unused_element

part of 'library_view.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  late LibraryCubit _libraryCubit;
  @override
  void initState() {
    _libraryCubit = context.read<LibraryCubit>();
    super.initState();
  }

  int getCrossAxisCount(BuildContext context) {
    final width = context.width;
    if (Platform.isAndroid || Platform.isIOS) {
      return width ~/ 120;
    }
    return width ~/ 150;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leadingWidth: 100,
          leading: BlocSelector<LibraryCubit, LibraryState, ExtensionType>(
            selector: (state) {
              return state.type;
            },
            builder: (context, type) {
              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: PopupMenuButton<ExtensionType>(
                  position: PopupMenuPosition.under,
                  initialValue: type,
                  onSelected: _libraryCubit.onChangeType,
                  clipBehavior: Clip.hardEdge,
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: ExtensionType.all,
                      child: Text("Tất cả"),
                    ),
                    const PopupMenuItem(
                        value: ExtensionType.movie, child: Text("Movie")),
                    const PopupMenuItem(
                        value: ExtensionType.comic, child: Text("Comic")),
                    const PopupMenuItem(
                        value: ExtensionType.novel, child: Text("Novel"))
                  ],
                  child: Row(
                    children: [
                      Gaps.wGap4,
                      Text(type.name.toTitleCase),
                      Gaps.wGap4,
                      const Icon(Icons.arrow_drop_down_rounded)
                    ],
                  ),
                ),
              );
            },
          ),
          title: Text(
            'library.title'.tr(),
            style: textTheme.titleMedium,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, RoutesName.searchBig);
                },
                icon: const Icon(Icons.search_rounded))
          ],
        ),
        body: BlocSelector<LibraryCubit, LibraryState, StateRes<List<Book>>>(
          selector: (state) {
            return state.stateBooks;
          },
          builder: (context, state) {
            if (state.status != StatusType.loaded) {
              return const LoadingWidget();
            }

            if (state.data == null || state.data!.isEmpty) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const RotatedBox(
                      quarterTurns: 1,
                      child: Icon(
                        Icons.web_stories_outlined,
                        size: 50,
                      ),
                    ),
                    Gaps.hGap12,
                    Text(
                      "Thư viện trống",
                      style: textTheme.bodyLarge,
                    )
                  ],
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: state.data!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: Dimens.getCrossAxisCount(context),
                  crossAxisSpacing: 8,
                  childAspectRatio: Dimens.bookAspectRatio,
                  mainAxisSpacing: 8),
              itemBuilder: (context, index) {
                final book = state.data![index];
                return _BookItem(
                  key: ValueKey(book.id ?? book.name),
                  index: index,
                  isLibrary: true,
                  book: book,
                  onTap: (value) {
                    Navigator.pushNamed(context, RoutesName.reader,
                        arguments: ReaderArgs(
                          book: value,
                          track: value.trackRead.value!,
                        ));
                  },
                  onLongTap: (value) {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          height: 1200,
                          child: ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await _libraryCubit.onDeleteBook(value);
                              },
                              child: const Text("DELETE")),
                        );
                      },
                    );
                  },
                  getBookById: (id) => _libraryCubit.getBookById(id),
                );
              },
            );
          },
        ));
  }
}

class _BookItem extends StatefulWidget {
  const _BookItem(
      {super.key,
      required this.book,
      required this.onTap,
      required this.onLongTap,
      required this.isLibrary,
      required this.index,
      required this.getBookById});
  final Book book;
  final ValueChanged<Book> onTap;
  final ValueChanged<Book> onLongTap;
  final Future<Book?> Function(int id) getBookById;
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
    final book = await widget.getBookById(widget.book.id!);
    // print("load");
    if (book != null) {
      setState(() {
        _book = book;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BookItem(
      book: _book,
      onTap: (book) => widget.onTap(book),
      onLongTap: (book) => widget.onLongTap(book),
      showType: true,
      showTrack: true,
      showDescription: false,
    );
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}
