import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quickblox_sdk_example/credentials.dart';
import 'package:quickblox_sdk_example/utils/dialog_utils.dart';
import 'package:quickblox_sdk_example/utils/snackbar_utils.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Settings'),
          centerTitle: true,
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop()),
        ),
        body: Center(
            child: Column(children: [
          MaterialButton(
            minWidth: 200,
            child: Text('init credentials'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: init,
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('get'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: get,
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('enable carbons'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: enableCarbons,
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('disable carbons'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: disableCarbons,
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('init stream management'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: initStreamManagement,
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('enable auto reconnect'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: enableAutoReconnect,
          )
        ])));
  }

  Future<void> init() async {
    try {
      await QB.settings.init(APP_ID, AUTH_KEY, AUTH_SECRET, ACCOUNT_KEY,
          apiEndpoint: API_ENDPOINT, chatEndpoint: CHAT_ENDPOINT);
      SnackBarUtils.showResult(_scaffoldKey, "The credentails was set");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> get() async {
    try {
      Map<String, Object> map = await QB.settings.get();
      SnackBarUtils.showResult(
          _scaffoldKey, "The credentials were loaded: \n $map");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> enableCarbons() async {
    try {
      await QB.settings.enableCarbons();
      SnackBarUtils.showResult(_scaffoldKey, "Carbon was enabled");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> disableCarbons() async {
    try {
      await QB.settings.disableCarbons();
      SnackBarUtils.showResult(_scaffoldKey, "Carbon was disabled");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> initStreamManagement() async {
    bool autoReconnect = true;
    int messageTimeout = 3;
    try {
      await QB.settings
          .initStreamManagement(messageTimeout, autoReconnect: autoReconnect);
      SnackBarUtils.showResult(_scaffoldKey,
          "Stream management was initiated with timeout $messageTimeout");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> enableAutoReconnect() async {
    bool enable = true;

    try {
      await QB.settings.enableAutoReconnect(enable);
      SnackBarUtils.showResult(
          _scaffoldKey, "Auto reconnect was changed to : $enable");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }
}
