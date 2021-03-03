import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quickblox_sdk_example/credentials.dart';
import 'package:quickblox_sdk_example/utils/dialog_utils.dart';
import 'package:quickblox_sdk_example/utils/snackbar_utils.dart';

class UsersScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Users'),
          centerTitle: true,
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop()),
        ),
        body: Center(
            child: Column(children: [
          MaterialButton(
            minWidth: 200,
            child: Text('create user'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: createUser,
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('get users'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: getUsers,
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('get users by tag'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: getUsersByTag,
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('update user'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: updateUser,
          )
        ])));
  }

  Future<void> createUser() async {
    String login = "FLUTTER_USER_" + new DateTime.now().millisecond.toString();
    String password = "FlutterPassword";
    try {
      QBUser user = await QB.users.createUser(login, password);
      int userId = user.id;
      SnackBarUtils.showResult(_scaffoldKey,
          "User was created: \n login: $login \n password: $password \n id: $userId");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> getUsers() async {
    try {
      List<QBUser> userList = await QB.users.getUsers();
      int count = userList.length;
      SnackBarUtils.showResult(
          _scaffoldKey, "Users were loaded. Count is: $count");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> getUsersByTag() async {
    List<String> tags = List();
    tags.add("TestUserTag");

    try {
      List<QBUser> userList = await QB.users.getUsersByTag(tags);
      int count = userList.length;
      SnackBarUtils.showResult(
          _scaffoldKey, "Users were loaded. Count is: $count");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> updateUser() async {
    String login = USER_LOGIN;
    try {
      QBUser user = await QB.users.updateUser(login);
      String email = user.email;
      SnackBarUtils.showResult(
          _scaffoldKey, "User with email $email was updated");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }
}
