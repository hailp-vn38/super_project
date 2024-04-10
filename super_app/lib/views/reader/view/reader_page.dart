part of 'reader_view.dart';

class ReaderPage extends StatefulWidget {
  const ReaderPage({super.key});

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  late ReaderCubit _readerCubit;
  @override
  void initState() {
    _readerCubit = context.read<ReaderCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return switch (_readerCubit.args.book.type) {
    //   ExtensionType.movie => const WatchMoviesView(),
    //   ExtensionType.novel => const ReadNovelView(),
    //   ExtensionType.comic => const ReadComicView(),
    //   _ => const Scaffold(),
    // };

    return Scaffold(
      body: BlocBuilder<ReaderCubit, ReaderState>(
        buildWhen: (previous, current) =>
            previous.loadExtensionErr != current.loadExtensionErr,
        builder: (context, state) {
          if (state.loadExtensionErr) {
            return Column(
              children: [
                AppBar(
                  title: Text(_readerCubit.book?.name ?? ""),
                ),
                const Expanded(
                    child: Center(
                        child: Text(
                            "Extension chưa cài đạt hoặc host web đã thay đổi")))
              ],
            );
          }
          return switch (_readerCubit.args.book.type) {
            ExtensionType.movie => const WatchMoviesView(),
            ExtensionType.novel => const ReadNovelView(),
            ExtensionType.comic => const ReadComicView(),
            _ => const Scaffold(),
          };
        },
      ),
    );
  }
}
