part of 'home_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeCubit _homeCubit;

  final database = getIt.get<DatabaseService>();
  @override
  void initState() {
    _homeCubit = context.read<HomeCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getIt.allReady(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(
                child: Text('The first real Page of your App'),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(centerTitle: true, title: const Text("Home")),
              body: SizedBox(
                width: context.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          const extUrl =
                              "https://raw.githubusercontent.com/lamphuchai-dev/super_app/main/extensions/extensions/truyencv/extension.zip";
                          final bytes = await DioClient().get(extUrl,
                              options:
                                  Options(responseType: ResponseType.bytes));
                          database.insertExtensionByUrl(bytes, extUrl);
                        },
                        child: const Text("CALL")),
                    ElevatedButton(
                        onPressed: () async {
                          // final extService = getIt<ExtensionService>();
                          // final ext = await extService.getExtensionFirst;
                        },
                        child: const Text("GET")),
                    ElevatedButton(
                        onPressed: () async {
                          final book = Book.fromMap(rawBook);
                          database.insertBook(book);
                        },
                        child: const Text("Add")),
                    ElevatedButton(
                        onPressed: () async {
                          final isar = getIt.get<DBStore>().isar;

                          final book = await isar.books.where().findFirst();
                          if (book == null) return;
                          final chapters = rawChapters
                              .map((e) => Chapter.fromMap(e))
                              .toList();
                          database.addChaptersInBook(
                              book: book, chapters: chapters);
                        },
                        child: const Text("Add Chapter")),
                    ElevatedButton(
                        onPressed: () async {
                          final isar = getIt.get<DBStore>().isar;

                          final book = await isar.books.where().findFirst();
                          database.deleteBook(book!);
                        },
                        child: const Text("Delete"))
                  ],
                ),
              ),
            );
          }
        });
  }
}

final rawBook = {
  "name": "Book 1",
  "url": "https://google.com.vn",
  "author": "test",
  "description": "Tets data",
  "status": "Complete",
  "type": "novel",
};

final rawChapters = [
  {"name": "Chapter 1", "url": "chapter/1/1"},
  {"name": "Chapter 1", "url": "chapter/1/1"}
];
