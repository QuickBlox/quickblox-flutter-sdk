import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_sdk/file/constants.dart';
import 'package:quickblox_sdk/models/qb_file.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quickblox_sdk_example/utils/dialog_utils.dart';
import 'package:quickblox_sdk_example/utils/snackbar_utils.dart';

class ContentScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _fileUrl;
  String _fileUid;
  int _fileId;

  StreamSubscription _uploadProgressSubscription;

  @override
  void dispose() {
    super.dispose();
    unsubscribeUpload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('File'),
          centerTitle: true,
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop()),
        ),
        body: Center(
            child: Column(children: [
          MaterialButton(
            minWidth: 200,
            child: Text('subscribe upload progress'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: () {
              subscribeUpload();
            },
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('unsubscribe upload progress'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: () {
              unsubscribeUpload();
            },
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('upload'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: upload,
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('get info'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: getInfo,
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('get public URL'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: getPublicURL,
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('get private URL'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: getPrivateURL,
          ),
        ])));
  }

  Future<void> subscribeUpload() async {
    if (_uploadProgressSubscription != null) {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You already have a subscriprion: " +
              QBFileUploadProgress.FILE_UPLOAD_PROGRESS);
      return;
    }

    try {
      _uploadProgressSubscription = await QB.content.subscribeUploadProgress(
          _fileUrl, QBFileUploadProgress.FILE_UPLOAD_PROGRESS, (data) {
        String progress = data["payload"]["progress"].toString();
        String url = data["payload"]["url"];
        SnackBarUtils.showResult(
            _scaffoldKey, "Progress value is: $progress \n for url $url");
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(_scaffoldKey,
          "Subscripbed: " + QBFileUploadProgress.FILE_UPLOAD_PROGRESS);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void unsubscribeUpload() async {
    if (_uploadProgressSubscription != null) {
      _uploadProgressSubscription.cancel();
      _uploadProgressSubscription = null;

      await QB.content.unsubscribeUploadProgress(
          _fileUrl, QBFileUploadProgress.FILE_UPLOAD_PROGRESS);

      SnackBarUtils.showResult(_scaffoldKey,
          "Unsubscribed: " + QBFileUploadProgress.FILE_UPLOAD_PROGRESS);
    } else {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You didn't have a subscription for: " +
              QBFileUploadProgress.FILE_UPLOAD_PROGRESS);
    }
  }

  Future<void> upload() async {
    try {
      QBFile file = await QB.content.upload(_fileUrl);
      int id = file.id;
      SnackBarUtils.showResult(_scaffoldKey, "The file $id was uploaded");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> getInfo() async {
    try {
      QBFile file = await QB.content.getInfo(_fileId);
      int id = file.id;
      SnackBarUtils.showResult(_scaffoldKey, "The file $id was loaded");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> getPublicURL() async {
    try {
      String url = await QB.content.getPublicURL(_fileUid);
      SnackBarUtils.showResult(_scaffoldKey, "Url $url was loaded");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> getPrivateURL() async {
    try {
      String url = await QB.content.getPrivateURL(_fileUid);
      SnackBarUtils.showResult(_scaffoldKey, "Url $url was loaded");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }
}
