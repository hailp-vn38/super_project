
part of 'read_novel_view.dart';

class ReadNovelPage extends StatefulWidget {
  const ReadNovelPage({super.key});

  @override
  State<ReadNovelPage> createState() => _ReadNovelPageState();
}

class _ReadNovelPageState extends State<ReadNovelPage> {

  late ReadNovelCubit _readNovelCubit;
  @override
  void initState() {
    _readNovelCubit = context.read<ReadNovelCubit>();
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Read novel")),
      body: SizedBox(),
    );
  }
}