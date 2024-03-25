part of 'splash_view.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Splash")),
      body: BlocConsumer<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is AppReady) {
            Navigator.pushNamedAndRemoveUntil(
                context, RoutesName.explore, (route) => false);
          }
        },
        builder: (context, state) {
          if (state is AppReady) {
            return const Text("ok");
          }
          return const Center(
            child: Text("Loading ..."),
          );
        },
      ),
    );
  }
}
