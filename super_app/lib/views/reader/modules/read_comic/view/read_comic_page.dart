part of 'read_comic_view.dart';

class ReadComicPage extends StatefulWidget {
  const ReadComicPage({super.key});

  @override
  State<ReadComicPage> createState() => _ReadComicPageState();
}

class _ReadComicPageState extends State<ReadComicPage> {
  late ReadComicCubit _readComicCubit;
  @override
  void initState() {
    _readComicCubit = context.read<ReadComicCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Read comic")),
      body: SizedBox(),
    );
  }
}
