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
    return switch (_readerCubit.args.book.type) {
      ExtensionType.movie => const WatchMoviesView(),
      ExtensionType.novel => const WatchMoviesView(),
      ExtensionType.comic => const WatchMoviesView(),
      _ => const Scaffold(),
    };
  }
}
