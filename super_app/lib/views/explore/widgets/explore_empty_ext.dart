part of '../view/explore_view.dart';

class ExploreEmptyExt extends StatelessWidget {
  const ExploreEmptyExt({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          child: const Text("Cài đặt nguồn"),
          onPressed: () {
            Navigator.pushNamed(context, RoutesName.extensions);
          },
        ),
      ),
    );
  }
}
