import 'package:flutter/material.dart';

class DialogUtils {
  static void showAlertDialog(BuildContext context,
      {String? title, String? content}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title ?? "Notification"),
          content: Text(content ?? ""),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
