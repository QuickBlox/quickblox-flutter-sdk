import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_sdk/auth/module.dart';
import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quickblox_sdk_example/credentials.dart';
import 'package:quickblox_sdk_example/data_holder.dart';
import 'package:quickblox_sdk_example/utils/dialog_utils.dart';
import 'package:quickblox_sdk_example/utils/snackbar_utils.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Auth'),
          centerTitle: true,
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop()),
        ),
        body: Center(
            child: Column(children: [
          MaterialButton(
            minWidth: 200,
            child: Text('login'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: login,
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('logout'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: logout,
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('set session'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: setSession,
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('get session'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: getSession,
          ),
        ])));
  }

  Future<void> login() async {
    try {
      QBLoginResult result = await QB.auth.login(USER_LOGIN, USER_PASSWORD);

      QBUser qbUser = result.qbUser;
      QBSession qbSession = result.qbSession;

      DataHolder.getInstance().setSession(qbSession);
      DataHolder.getInstance().setUser(qbUser);

      SnackBarUtils.showResult(_scaffoldKey, "Login success");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> logout() async {
    try {
      await QB.auth.logout();
      SnackBarUtils.showResult(_scaffoldKey, "Logout success");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> setSession() async {
    try {
      QBSession qbSession = DataHolder.getInstance().getSession();

      QBSession sessionResult = await QB.auth.setSession(qbSession);

      if (sessionResult != null) {
        DataHolder.getInstance().setSession(sessionResult);
        SnackBarUtils.showResult(_scaffoldKey, "Set session success");
      } else {
        DialogUtils.showError(context, Exception("The session in null"));
      }
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> getSession() async {
    try {
      QBSession session = await QB.auth.getSession();
      if (session != null) {
        DataHolder.getInstance().setSession(session);
        SnackBarUtils.showResult(_scaffoldKey, "Get session success");
      } else {
        DialogUtils.showError(context, Exception("The session in null"));
      }
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }
}
