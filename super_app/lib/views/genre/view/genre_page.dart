part of './genre_view.dart';

class GenrePage extends StatefulWidget {
  const GenrePage({super.key});

  @override
  State<GenrePage> createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  late GenreCubit _genreCubit;
  @override
  void initState() {
    _genreCubit = context.read<GenreCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: Text(_genreCubit.titleGenre)),
      body: BooksWidget(
        url: _genreCubit.getGenre.url!,
        onFetchListBook: (url, page) {
          return _genreCubit.onGetListBook(page);
        },
        onTap: (book) {
          Navigator.pushNamed(context, RoutesName.detail,
              arguments: book.url!.replaceUrl(_genreCubit.getExtension.source));
        },
      ),
    );
  }
}
