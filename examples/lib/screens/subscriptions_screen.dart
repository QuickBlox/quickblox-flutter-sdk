import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_sdk/models/qb_subscription.dart';
import 'package:quickblox_sdk/push/constants.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quickblox_sdk_example/utils/dialog_utils.dart';
import 'package:quickblox_sdk_example/utils/snackbar_utils.dart';

class SubscriptionsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Subscriptions'),
          centerTitle: true,
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop()),
        ),
        body: Center(
            child: Column(children: [
          MaterialButton(
            minWidth: 200,
            child: Text('create push subscription'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: createPushSubscription,
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('get push subscriptions'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: getPushSubscriptions,
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('remove push subscription'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: removePushSubscription,
          )
        ])));
  }

  Future<void> createPushSubscription() async {
    String deviceToken = "test";

    try {
      List<QBSubscription> subscriptions =
          await QB.subscriptions.create(deviceToken, QBPushChannelNames.GCM);
      SnackBarUtils.showResult(
          _scaffoldKey, "Push was created with token: $deviceToken");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> getPushSubscriptions() async {
    try {
      List<QBSubscription> subscriptions = await QB.subscriptions.get();
      int count = subscriptions.length;
      SnackBarUtils.showResult(
          _scaffoldKey, "Push Subscriptions were loaded: $count");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> removePushSubscription() async {
    int id = 0;

    try {
      await QB.subscriptions.remove(id);
      SnackBarUtils.showResult(
          _scaffoldKey, "Push subcription with id: $id was removed");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }
}
