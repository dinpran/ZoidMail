import 'package:flutter/material.dart';

void nextscreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplacement(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

void showsnackbar(context, message, color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: Colors.orange,
    duration: Duration(seconds: 2),
    action: SnackBarAction(label: "OK", onPressed: () {}),
  ));
}
