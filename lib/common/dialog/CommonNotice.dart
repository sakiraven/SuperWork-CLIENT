import 'package:flutter/material.dart';

class CommonNotice {
  static Future<void> show(BuildContext context,String message) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('提示'),
          content: SingleChildScrollView(
            child: Center(
              child: Text(message),
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              child: const Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then((val) {
    });
  }
}
