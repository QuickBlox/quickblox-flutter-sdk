import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DialogUtils {
  static DialogUtils _instance = new DialogUtils.internal();

  DialogUtils.internal();

  factory DialogUtils() => _instance;

  static void showError(BuildContext context, PlatformException exception) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(
                exception.code == "error" ? exception.message : exception.code),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  static void showOneBtn(BuildContext context, String titleText) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(titleText),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  static void showTwoBtn(BuildContext context, String titleText,
      Function accept, Function decline) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(titleText),
            actions: <Widget>[
              FlatButton(
                  child: Text("Accept"),
                  onPressed: () {
                    accept(null);
                    Navigator.pop(context);
                  }),
              FlatButton(
                  child: Text("Decline"),
                  onPressed: () {
                    decline(null);
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }
}
