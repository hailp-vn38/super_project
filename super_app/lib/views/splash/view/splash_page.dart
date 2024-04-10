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
      body: BlocConsumer<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state.status != StatusType.loaded) return;
          Navigator.pushNamedAndRemoveUntil(
              context, RoutesName.tabs, (route) => false);
        },
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) => switch (state.status) {
          StatusType.error => const Center(
              child: Text("Err"),
            ),
          _ => const Center(
              child: LoadingWidget(),
            )
        },
      ),
    );
  }
}
