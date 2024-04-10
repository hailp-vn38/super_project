part of '../view/explore_view.dart';

class ExploreEmptyExt extends StatelessWidget {
  const ExploreEmptyExt({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "explore.title".tr(),
          style: textTheme.titleMedium,
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.extension_off_rounded,
              size: 50,
            ),
            Gaps.hGap16,
            Text(
              "Nguồn chưa được cài đặt",
              style: textTheme.titleMedium,
            )
          ],
        ),
      ),
    );
  }
}
