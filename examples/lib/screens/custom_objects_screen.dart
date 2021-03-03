import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_sdk/models/qb_custom_object.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quickblox_sdk_example/credentials.dart';
import 'package:quickblox_sdk_example/utils/dialog_utils.dart';
import 'package:quickblox_sdk_example/utils/snackbar_utils.dart';

class CustomObjectsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CustomObjectsScreenState();
}

class _CustomObjectsScreenState extends State<CustomObjectsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Custom Objects'),
          centerTitle: true,
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop()),
        ),
        body: Center(
            child: Column(children: [
          MaterialButton(
            minWidth: 200,
            child: Text('create'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: createCustomObject,
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('remove'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: removeCustomObject,
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('get by ids'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: getCustomObjectsByIds,
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('get'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: getCustomObject,
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('update'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: updateCustomObject,
          ),
        ])));
  }

  Future<void> createCustomObject() async {
    Map<String, Object> fieldsMap = Map();
    fieldsMap['testString'] = "testFiled";
    fieldsMap['testInteger'] = 123;
    fieldsMap['testBoolean'] = true;

    try {
      List<QBCustomObject> customObjectsList = await QB.data
          .create(className: CUSTOM_OBJECT_ClASS_NAME, fields: fieldsMap);
      QBCustomObject customObject = customObjectsList[0];
      String id = customObject.id;
      SnackBarUtils.showResult(_scaffoldKey,
          "The class $CUSTOM_OBJECT_ClASS_NAME  was created \n ID: $id");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> removeCustomObject() async {
    List<String> ids = [""];
    try {
      await QB.data.remove(CUSTOM_OBJECT_ClASS_NAME, ids);
      SnackBarUtils.showResult(_scaffoldKey, "The ids: $ids were removed");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> getCustomObjectsByIds() async {
    List<String> ids = ["", ""];
    try {
      List<QBCustomObject> customObjects =
          await QB.data.getByIds(CUSTOM_OBJECT_ClASS_NAME, ids);
      int size = customObjects.length;
      SnackBarUtils.showResult(
          _scaffoldKey, "Loaded custom objects size: $size");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> getCustomObject() async {
    try {
      List<QBCustomObject> customObjects =
          await QB.data.get(CUSTOM_OBJECT_ClASS_NAME);
      int size = customObjects.length;
      SnackBarUtils.showResult(
          _scaffoldKey, "Loaded custom objects size: $size");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> updateCustomObject() async {
    String objectId = "";

    try {
      QBCustomObject customObject =
          await QB.data.update(CUSTOM_OBJECT_ClASS_NAME, id: objectId);
      String id = customObject.id;
      SnackBarUtils.showResult(
          _scaffoldKey, "The custom object $id was updated");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }
}
