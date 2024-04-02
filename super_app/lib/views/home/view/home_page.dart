// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeCubit _homeCubit;

  // final database = getIt.get<DatabaseService>();

  @override
  void initState() {
    _homeCubit = context.read<HomeCubit>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: Column(
      children: [ElevatedButton(onPressed: () async {}, child: Text("data"))],
    ));
  }
}
