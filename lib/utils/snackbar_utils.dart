import 'package:flutter/material.dart';

class SnackBarUtils {
  static void showResult(GlobalKey<ScaffoldState> scaffoldKey, String text) {
    if (scaffoldKey.currentState != null) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
          duration: const Duration(seconds: 1), content: new Text(text)));
    } else {
      print(text);
    }
  }
}
