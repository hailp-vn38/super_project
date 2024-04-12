part of 'search_big_view.dart';

class SearchBigPage extends StatefulWidget {
  const SearchBigPage({super.key});

  @override
  State<SearchBigPage> createState() => _SearchBigPageState();
}

class _SearchBigPageState extends State<SearchBigPage> {
  late SearchBigCubit _searchBigCubit;
  @override
  void initState() {
    _searchBigCubit = context.read<SearchBigCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.appTextTheme;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: SizedBox(
            height: 40,
            child: TextField(
              controller: _searchBigCubit.textEditingController,
              textInputAction: TextInputAction.search,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none),
                filled: true,
                hintText: "Nhập để tìm kiếm",
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                suffixIcon: IconButton(
                    onPressed: () {
                      final types = _searchBigCubit.types;
                      showDialog(
                        context: context,
                        builder: (context) => NewWidget(
                          types: _searchBigCubit.types,
                          onChange: _searchBigCubit.onChangeType,
                        ),
                      ).then((value) {
                        if (types == _searchBigCubit.types) {
                          return;
                        }
                        _searchBigCubit.onCloseDialog();
                      });
                    },
                    icon: Icon(
                      Icons.tune_rounded,
                      color: colorScheme.primary,
                    )),
              ),
              onSubmitted: (value) {
                if (value == "") return;
                _searchBigCubit.onSearch();
              },
            ),
          ),
        ),
        body: TabBarView(children: [
          KeepAliveWidget(
              child: BlocSelector<SearchBigCubit, SearchBigState,
                  StateRes<List<Book>>>(
            selector: (state) {
              return state.stateBooks;
            },
            builder: (context, stateBooks) {
              return SafeArea(
                child: switch (stateBooks.status) {
                  StatusType.loading => const LoadingWidget(),
                  StatusType.loaded => stateBooks.data!.isEmpty
                      ? _dataEmpty(textTheme)
                      : BooksWidget(
                          url: "",
                          initialData: stateBooks.data,
                          showDes: false,
                          showTrack: true,
                          showType: true,
                          onFetchListBook: (url, page) async => [],
                          onTap: (book) {
                            Navigator.pushNamed(context, RoutesName.reader,
                                arguments: ReaderArgs(
                                    book: book,
                                    chapters: book.chapters.toList(),
                                    track: book.trackRead.value!,
                                    extension: null));
                          },
                        ),
                  _ => const SizedBox()
                },
              );
            },
          )),
          KeepAliveWidget(
            child: Column(
              children: [
                Expanded(
                    child: BlocSelector<SearchBigCubit, SearchBigState,
                        StateRes<List<Extension>>>(
                  selector: (state) => state.stateRes,
                  builder: (context, stateRes) {
                    return switch (stateRes.status) {
                      StatusType.loading => const Center(
                          child: LoadingWidget(),
                        ),
                      StatusType.loaded => stateRes.data!.isEmpty
                          ? _dataEmpty(textTheme)
                          : SingleChildScrollView(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                key: ValueKey(
                                    _searchBigCubit.textEditingController.text),
                                children: stateRes.data!
                                    .map((e) => SearchExtension(
                                          extension: e,
                                          searchWord: _searchBigCubit
                                              .textEditingController.text,
                                          onSearch: () => _searchBigCubit
                                              .searchByExtension(e),
                                        ))
                                    .toList(),
                              ),
                            ),
                      _ => const SizedBox()
                    };
                  },
                )),
              ],
            ),
          )
        ]),
        bottomNavigationBar: ColoredBox(
          color: colorScheme.background,
          child: const SafeArea(
            child: TabBar(padding: EdgeInsets.zero, tabs: [
              Tab(
                text: "Thư viện",
              ),
              Tab(
                text: "Nguồn",
              )
            ]),
          ),
        ),
      ),
    );
  }

  SizedBox _dataEmpty(TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.extension_off_rounded,
            size: 50,
          ),
          Gaps.hGap16,
          Text(
            "Không có dữ liệu hiện thị",
            style: textTheme.titleMedium,
          )
        ],
      ),
    );
  }
}

class NewWidget extends StatefulWidget {
  const NewWidget({super.key, required this.types, required this.onChange});

  final List<ExtensionType> types;

  final ValueChanged<List<ExtensionType>> onChange;

  @override
  State<NewWidget> createState() => _NewWidgetState();
}

class _NewWidgetState extends State<NewWidget> {
  List<ExtensionType> _types = [];

  @override
  void initState() {
    _types = widget.types;
    super.initState();
  }

  bool isSelect(ExtensionType type) {
    final result = _types.firstWhereOrNull((element) => element == type);
    return result != null;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    final colorScheme = context.colorScheme;
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.hGap10,
            Text(
              "Tìm kiếm theo",
              style: textTheme.titleMedium,
            ),
            Gaps.hGap10,
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    final result = isSelect(ExtensionType.movie);

                    if (result) {
                      _types = _types
                          .where((element) => element != ExtensionType.movie)
                          .toList();
                    } else {
                      _types = [..._types, ExtensionType.movie];
                    }
                    setState(() {});
                    widget.onChange(_types);
                  },
                  child: Card(
                    elevation: 0.7,
                    color: isSelect(ExtensionType.movie)
                        ? colorScheme.primaryContainer
                        : null,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: Text(
                          "Movie",
                          style: textTheme.labelMedium
                              ?.copyWith(color: colorScheme.primary),
                        )),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    final result = isSelect(ExtensionType.novel);

                    if (result) {
                      _types = _types
                          .where((element) => element != ExtensionType.novel)
                          .toList();
                    } else {
                      _types = [..._types, ExtensionType.novel];
                    }
                    setState(() {});
                    widget.onChange(_types);
                  },
                  child: Card(
                    elevation: 0.7,
                    color: isSelect(ExtensionType.novel)
                        ? colorScheme.primaryContainer
                        : null,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: Text(
                          "Novel",
                          style: textTheme.labelMedium
                              ?.copyWith(color: colorScheme.primary),
                        )),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    final result = isSelect(ExtensionType.comic);

                    if (result) {
                      _types = _types
                          .where((element) => element != ExtensionType.comic)
                          .toList();
                    } else {
                      _types = [..._types, ExtensionType.comic];
                    }
                    setState(() {});
                    widget.onChange(_types);
                  },
                  child: Card(
                    elevation: 0.7,
                    color: isSelect(ExtensionType.comic)
                        ? colorScheme.primaryContainer
                        : null,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: Text(
                          "Comic",
                          style: textTheme.labelMedium
                              ?.copyWith(color: colorScheme.primary),
                        )),
                  ),
                ),
              ],
            ),
            Gaps.hGap12,
          ],
        ),
      ),
    );
  }
}

class SearchExtension extends StatefulWidget {
  const SearchExtension(
      {super.key,
      required this.extension,
      required this.onSearch,
      required this.searchWord});
  final Extension extension;
  final Future<List<Book>> Function() onSearch;
  final String searchWord;

  @override
  State<SearchExtension> createState() => _SearchExtensionState();
}

class _SearchExtensionState extends State<SearchExtension> {
  // bool _isLoading = false;
  // List<Book> _listBook = [];
  @override
  void initState() {
    // _search();
    super.initState();
  }

  // void _search() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   _listBook = await widget.onSearch.call();

  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    final colorScheme = context.colorScheme;
    return Container(
      height: DeviceUtils.isMobile ? 280 : 330,
      margin: const EdgeInsets.only(bottom: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gaps.hGap8,
          SizedBox(
            height: 50,
            child: Row(
              children: [
                AspectRatio(
                  aspectRatio: 3 / 4,
                  child: ImageWidget(
                    image: widget.extension.metadata.icon,
                  ),
                ),
                Gaps.wGap12,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.extension.metadata.name ?? "",
                      style: textTheme.titleMedium,
                    ),
                    ExtensionTag(text: widget.extension.metadata.type!.title)
                  ],
                ),
                Expanded(
                    child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RoutesName.search,
                          arguments: SearchArgs(
                              extension: widget.extension,
                              searchWord: widget.searchWord));
                    },
                    child: const Text("Xêm thêm"),
                  ),
                ))
              ],
            ),
          ),
          Gaps.hGap4,
          Expanded(
              flex: 4,
              child: FutureBuilder<List<Book>>(
                future: widget.onSearch(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Có lỗi khi lấy dữ liệu"),
                      );
                    } else if (snapshot.hasData) {
                      final data = snapshot.data;
                      if (data == null || data.isEmpty) {
                        return const Center(
                          child: Text("Không có dữ liệu"),
                        );
                      }
                      return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: data
                                .map((book) => Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 1, right: 8),
                                      child: SizedBox(
                                        width: Dimens.getWithBookChild,
                                        child: BookItem(
                                          book: book,
                                          onTap: (book) {
                                            Navigator.pushNamed(
                                                context, RoutesName.detail,
                                                arguments: book.url?.replaceUrl(
                                                    widget.extension.source));
                                          },
                                          onLongTap: (book) {},
                                          showType: false,
                                          showTrack: false,
                                          showDescription: true,
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ));
                    }
                  }
                  return const Center(
                      child: LoadingWidget(
                    radius: 14,
                  ));
                },
              ))
        ],
      ),
    );
  }
}
