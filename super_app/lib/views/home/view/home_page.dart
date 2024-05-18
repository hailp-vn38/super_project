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
    // _homeCubit = context.read<HomeCubit>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return SizedBox.expand(
    //     child: Column(
    //   children: [ElevatedButton(onPressed: () async {}, child: Text("data"))],
    // ));
    return MyScreen();
  }
}

class MyScreen extends StatefulWidget {
  const MyScreen({Key? key}) : super(key: key);
  @override
  State<MyScreen> createState() => MyScreenState();
}

class MyScreenState extends State<MyScreen> {
  // Create a [Player] to control playback.
  late final player = Player();
  // Create a [VideoController] to handle video output from [Player].
  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();
    // Play a [Media] or [Playlist].
    player.open(Media(
        'https://pt.rapovideo.xyz/playlist/65ad2d9b1340d0f88f42afe3/master.m3u8',
        httpHeaders: {"Access-Control-Allow-Origin": "https://animehay.blog"}));
    player.stream.error.listen((event) {
      print(event);
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * 9.0 / 16.0,
        // Use [Video] widget to display video output.
        child: Video(controller: controller),
      ),
    );
  }
}
