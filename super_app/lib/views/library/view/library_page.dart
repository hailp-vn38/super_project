
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

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Library")),
      body: SizedBox(),
    );
  }
}