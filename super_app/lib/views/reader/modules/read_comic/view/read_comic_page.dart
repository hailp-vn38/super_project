part of 'read_comic_view.dart';

class ReadComicPage extends StatefulWidget {
  const ReadComicPage({super.key});

  @override
  State<ReadComicPage> createState() => _ReadComicPageState();
}

class _ReadComicPageState extends State<ReadComicPage>
    with SingleTickerProviderStateMixin {
  late ReadComicCubit _readComicCubit;
  @override
  void initState() {
    _readComicCubit = context.read<ReadComicCubit>();
    _readComicCubit.setAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    return Scaffold(
      drawer: ChaptersDrawer(
        onChangeChapter: (chapter) {
          _readComicCubit.onChangeChapter(chapter);
        },
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _readComicCubit.onTapScreen,
              onPanCancel: () {
                _readComicCubit.onTouchScreen();
              },
              child: BlocConsumer<ReaderCubit, ReaderState>(
                listener: (context, state) {
                  if (state.readCurrentChapter.status == StatusType.loaded) {
                    // _readComicCubit.setSliderScroll(
                    //     state.readCurrentChapter.data!.scrollIndex ?? 0);
                  }
                },
                buildWhen: (previous, current) =>
                    previous.readCurrentChapter != current.readCurrentChapter,
                builder: (context, readerState) {
                  return switch (readerState.readCurrentChapter.status) {
                    StatusType.loaded => ListScroll(
                        key: ValueKey(
                            readerState.readCurrentChapter.data!.index),
                        controller: _readComicCubit.listScrollController,
                        initialScrollOffset:
                            readerState.readCurrentChapter.data!.offset,
                        children: readerState.readCurrentChapter.data!.comic!
                            .map((e) => KeepAliveWidget(
                                  child: ImageWidget(
                                    image: e,
                                    httpHeaders: _readComicCubit.getHttpHeaders,
                                    loading: true,
                                  ),
                                ))
                            .toList(),
                      ),
                    _ => const LoadingWidget()
                  };
                },
              ),
            ),
          ),
          BlocSelector<ReadComicCubit, ReadComicState, MenuComic>(
            selector: (state) {
              return state.menu;
            },
            builder: (context, menu) {
              return switch (menu) {
                MenuComic.base => BaseMenu(readComicCubit: _readComicCubit),
                MenuComic.autoScroll =>
                  AutoScrollMenu(readComicCubit: _readComicCubit),
              };
            },
          )
        ],
      ),
    );
  }
}

// class PhotoTmp extends StatelessWidget {
//   const PhotoTmp({super.key, required this.images, required this.headers});
//   final List<String> images;
//   final Map<String, String>? headers;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: PhotoViewGallery.builder(
//       scrollPhysics: const BouncingScrollPhysics(),
//       builder: (BuildContext context, int index) {
//         return PhotoViewGalleryPageOptions(
//           imageProvider: NetworkImage(images[index], headers: headers),
//           initialScale: PhotoViewComputedScale.contained * 0.8,
//           // heroAttributes: PhotoViewHeroAttributes(tag: galleryItems[index].id),
//         );
//       },
//       allowImplicitScrolling: true,
//       itemCount: images.length,
//       scrollDirection: Axis.vertical,
//       loadingBuilder: (context, event) => Center(
//         child: Container(
//           width: 20.0,
//           height: 20.0,
//           child: CircularProgressIndicator(),
//         ),
//       ),
//       // backgroundDecoration: widget.backgroundDecoration,
//       // pageController: widget.pageController,
//       // onPageChanged: onPageChanged,
//     ));
//   }
// }
