// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Error'),
      content: Text(errorMessage),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
            print(errorMessage);
          },
        ),
      ],
    ),
  );
}
