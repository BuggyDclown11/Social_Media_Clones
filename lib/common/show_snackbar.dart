import 'package:flutter/material.dart';

class ShowSnack {
  static showSuccessSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
        content: Text(msg)));
  }

  static showErrorSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
        content: Text(
          msg,
          style: TextStyle(color: Colors.black38),
        )));
  }
}
