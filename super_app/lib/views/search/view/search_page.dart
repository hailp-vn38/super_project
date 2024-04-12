part of 'search_view.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late SearchCubit _searchCubit;
  late FocusNode _focusNode;
  @override
  void initState() {
    _focusNode = FocusNode();
    _searchCubit = context.read<SearchCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: TextField(
          focusNode: _focusNode,
          controller: _searchCubit.getTextEditingController,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            filled: false,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: "Nhập nội dung tìm kiếm",
          ),
          onEditingComplete: () {
            _focusNode.unfocus();
            _searchCubit.onSearch();
          },
        ),
        actions: [
          IconButton(
              splashRadius: 20,
              onPressed: () {
                _searchCubit.getTextEditingController.clear();
                _focusNode.requestFocus();
              },
              icon: const Icon(Icons.close_rounded))
        ],
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return SafeArea(
            child: switch (state.status) {
              StatusType.loading => const LoadingWidget(),
              StatusType.loaded => BooksWidget(
                  url: "",
                  initialData: state.books,
                  showDes: true,
                  // initialBooks: state.books,
                  // useFetch: false,
                  // useRefresh: false,
                  onFetchListBook: (url, page) =>
                      _searchCubit.onLoadMoreSearch(page),
                  onTap: (book) {
                    Navigator.pushNamed(context, RoutesName.detail,
                        arguments: book.url!
                            .replaceUrl(_searchCubit.extension.source));
                  },
                ),
              _ => const SizedBox()
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchCubit.getTextEditingController.dispose();
    super.dispose();
  }
}
