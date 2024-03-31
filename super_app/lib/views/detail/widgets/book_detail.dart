part of '../view/detail_view.dart';

class BookDetail extends StatefulWidget {
  const BookDetail({super.key});

  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  late DetailCubit _detailCubit;

  final collapsedBarHeight = kToolbarHeight;
  final ScrollController _scrollController = ScrollController();
  ValueNotifier<bool> isCollapsed = ValueNotifier(false);
  final ValueNotifier<double> _offset = ValueNotifier(0.0);

  late Book _book;
  @override
  void initState() {
    _detailCubit = context.read<DetailCubit>();
    // _detailCubit.onInitFToat(context);
    _book = _detailCubit.bookState.data!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    final expandedBarHeight =
        (context.height * 0.3) < 250 ? 250.0 : (context.height * 0.3);
    const paddingAppBar = 16.0;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _detailCubit.onRefreshDetail,
        displacement: 56,
        child: NotificationListener(
          onNotification: (notification) {
            if (_scrollController.hasClients &&
                _scrollController.offset <=
                    (expandedBarHeight - collapsedBarHeight)) {
              _offset.value = _scrollController.offset / (expandedBarHeight);
            }

            if (_scrollController.hasClients &&
                _scrollController.offset >
                    (expandedBarHeight - collapsedBarHeight) &&
                !isCollapsed.value) {
              isCollapsed.value = true;
            } else if (!(_scrollController.hasClients &&
                    _scrollController.offset >
                        (expandedBarHeight - collapsedBarHeight)) &&
                isCollapsed.value) {
              isCollapsed.value = false;
            }
            return false;
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: expandedBarHeight,
                collapsedHeight: collapsedBarHeight,
                centerTitle: false,
                pinned: true,
                title: ValueListenableBuilder(
                  valueListenable: _offset,
                  builder: (context, value, child) => Opacity(
                    opacity: value.clamp(0.0, 1.0),
                    child: Text(_book.name!),
                  ),
                ),
                elevation: 0,
                // leading: const BackButton(
                //   color: Colors.white,
                // ),
                actions: [
                  BlocSelector<DetailCubit, DetailState, StatusType>(
                    selector: (state) {
                      return state.chaptersState.status;
                    },
                    builder: (context, status) {
                      return switch (status) {
                        StatusType.loaded => IconButton(
                            onPressed: () {
                              // _detailCubit.download();
                            },
                            icon: const Icon(Icons.download_rounded)),
                        _ => const SizedBox()
                      };
                    },
                  ),
                  BlocSelector<DetailCubit, DetailState, StatusType>(
                    selector: (state) {
                      return state.chaptersState.status;
                    },
                    builder: (context, status) {
                      return switch (status) {
                        StatusType.loaded => _book.id != null
                            ? IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.bookmark,
                                  // color: colorScheme.primary,
                                ))
                            : IconButton(
                                onPressed: () {
                                  // _detailCubit.addBookmark();
                                },
                                icon: const Icon(Icons.bookmark_add_rounded)),
                        _ => const SizedBox()
                      };
                    },
                  ),
                  IconButton(
                      onPressed: () {
                        // _detailCubit.openBrowser();
                      },
                      icon: const Icon(Icons.public))
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned.fill(
                          child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Positioned.fill(
                            bottom: 1,
                            right: 0,
                            left: 0,
                            child: ImageWidget(image: _book.cover),
                          ),
                          Positioned.fill(
                            child: ClipRect(
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 9, sigmaY: 9.0),
                                child: const SizedBox(),
                              ),
                            ),
                          ),
                        ],
                      )),
                      Positioned.fill(
                        top: kToolbarHeight,
                        bottom: paddingAppBar,
                        right: 0,
                        left: 0,
                        child: SafeArea(
                          child: Row(
                            children: [
                              Gaps.wGap16,
                              AspectRatio(
                                aspectRatio: 2 / 3,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: ImageWidget(image: _book.cover)),
                              ),
                              Gaps.wGap12,
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      child: Text(
                                        _book.name!,
                                        style: textTheme.titleMedium!
                                            .copyWith(color: Colors.white),
                                        maxLines: 2,
                                      ),
                                    ),
                                    Gaps.hGap4,
                                    if (_book.author != null)
                                      Text(
                                        _book.author!,
                                        maxLines: 2,
                                        style: textTheme.bodyMedium
                                            ?.copyWith(color: Colors.white),
                                      ),
                                    Gaps.hGap4,
                                    if (_book.status != null)
                                      Text(
                                        _book.status!,
                                        maxLines: 2,
                                        style: textTheme.bodyMedium
                                            ?.copyWith(color: Colors.white),
                                      ),
                                  ])),
                              Gaps.wGap16,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Thể loại",
                      style: textTheme.titleMedium,
                    ),
                    if (_detailCubit.state.genresState.data != null)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: _detailCubit.state.genresState.data!
                              .map((e) => GenreCard(
                                  genre: e,
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, RoutesName.genre,
                                        arguments: GenreArgs(
                                            genre: e,
                                            extension:
                                                _detailCubit.getExtension!));
                                  }))
                              .toList(),
                        ),
                      ),
                    Text(
                      "Giới thiệu",
                      style: textTheme.titleMedium,
                    ),
                    ExpandableText(
                      _book.description ?? "",
                      expandText: 'Xem thêm',
                      collapseText: '..Ẩn',
                      maxLines: 3,
                      animation: true,
                      linkColor: context.colorScheme.primary,
                    ),
                  ],
                ),
              )),
              MultiSliver(
                children: [
                  BlocSelector<DetailCubit, DetailState,
                      StateRes<List<Chapter>>>(
                    selector: (state) {
                      return state.chaptersState;
                    },
                    builder: (context, chaptersRes) {
                      return switch (chaptersRes.status) {
                        StatusType.loading => MultiSliver(children: [
                            SliverPinnedHeader(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 12),
                                decoration: BoxDecoration(
                                    // color: colorScheme.surface,
                                    borderRadius: BorderRadius.circular(4)),
                                child: const Row(
                                  children: [
                                    LoadingWidget(
                                      radius: 8,
                                    ),
                                    Gaps.wGap8,
                                    Expanded(
                                        child:
                                            Text("Đang lấy danh sách chương")),
                                  ],
                                ),
                              ),
                            )
                          ]),
                        StatusType.loaded => MultiSliver(
                            children: [
                              SliverPinnedHeader(
                                child: Card(
                                  margin: EdgeInsets.zero,
                                  borderOnForeground: false,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero),
                                  // padding: const EdgeInsets.only(
                                  //     left: 12, right: 4, top: 2, bottom: 2),
                                  // decoration: BoxDecoration(
                                  //     // color: colorScheme.surface,
                                  //     borderRadius: BorderRadius.circular(4)),
                                  child: Row(
                                    children: [
                                      Gaps.wGap16,
                                      Expanded(
                                          child: Text(
                                        "${chaptersRes.data!.length} chương",
                                        style: textTheme.titleMedium,
                                      )),
                                      IconButton(
                                          onPressed: () {
                                            // // _detailCubit.reverseChapters();
                                            // showSearch(
                                            //         context: context,
                                            //         delegate:
                                            //             ChapterSearchDelegate(
                                            //                 chapters:
                                            //                     _detailCubit
                                            //                         .chaptersState
                                            //                         .data!))
                                            //     .then((value) {
                                            //   if (value != null &&
                                            //       value is Chapter) {
                                            //     Navigator.pushNamed(context,
                                            //         RoutesName.reader,
                                            //         arguments: ReaderArgs(
                                            //             book: _book.copyWith(
                                            //                 currentIndex:
                                            //                     value
                                            //                         .index),
                                            //             chapters:
                                            //                 chaptersRes
                                            //                     .data!));
                                            //   }
                                            // });
                                          },
                                          icon:
                                              const Icon(Icons.search_rounded)),
                                      IconButton(
                                          onPressed: () {
                                            _detailCubit.reverseChapters();
                                          },
                                          icon: const Icon(Icons.sort))
                                    ],
                                  ),
                                ),
                              ),
                              SliverAnimatedPaintExtent(
                                duration: const Duration(seconds: 3),
                                child: SliverList.separated(
                                  itemCount: chaptersRes.data!.length,
                                  separatorBuilder: (context, index) =>
                                      const Divider(
                                    height: 1,
                                    endIndent: 12,
                                    indent: 12,
                                  ),
                                  itemBuilder: (context, index) {
                                    final chapter = chaptersRes.data![index];
                                    return MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, RoutesName.reader,
                                              arguments: ReaderArgs(
                                                  book: _book,
                                                  chapters: chaptersRes.data!,
                                                  track: TrackRead(
                                                    readCurrentChapter: index,
                                                  ),
                                                  extension: _detailCubit
                                                      .getExtension));
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 12),
                                          child: Text(
                                            chapter.name ?? "",
                                            style: textTheme.bodyMedium,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        StatusType.error => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(chaptersRes.message ?? "ERR"),
                          ),
                        _ => const SizedBox()
                      };
                    },
                  )
                ],
              ),
              const SliverToBoxAdapter(
                child: Gaps.hGap16,
              )
            ],
          ),
        ),
      ),
    );
  }
}
