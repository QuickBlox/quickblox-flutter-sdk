import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_sdk/models/qb_rtc_session.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quickblox_sdk/webrtc/constants.dart';
import 'package:quickblox_sdk/webrtc/rtc_video_view.dart';
import 'package:quickblox_sdk_example/credentials.dart';
import 'package:quickblox_sdk_example/utils/dialog_utils.dart';
import 'package:quickblox_sdk_example/utils/snackbar_utils.dart';

class WebRTCScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WebRTCScreenState();
}

class _WebRTCScreenState extends State<WebRTCScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _sessionId;

  RTCVideoViewController _localVideoViewController;
  RTCVideoViewController _remoteVideoViewController;

  bool _videoCall = true;

  StreamSubscription _callSubscription;
  StreamSubscription _callEndSubscription;
  StreamSubscription _rejectSubscription;
  StreamSubscription _acceptSubscription;
  StreamSubscription _hangUpSubscription;
  StreamSubscription _videoTrackSubscription;
  StreamSubscription _notAnswerSubscription;
  StreamSubscription _peerConnectionSubscription;

  @override
  void dispose() {
    super.dispose();

    unsubscribeCall();
    unsubscribeCallEnd();
    unsubscribeReject();
    unsubscribeAccept();
    unsubscribeHangUp();
    unsubscribeVideoTrack();
    unsubscribeNotAnswer();
    unsubscribePeerConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('WebRTC'),
          centerTitle: true,
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop()),
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Column(children: [
          MaterialButton(
            minWidth: 200,
            child: Text('init'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: init,
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('release'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: releaseWebRTC,
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('release Video Views'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: releaseVideoViews,
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('get session'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: getSessionWebRTC,
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('call Video'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: () {
              callWebRTC(QBRTCSessionTypes.VIDEO);
              setState(() {
                _videoCall = true;
              });
            },
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('call Audio'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: () {
              callWebRTC(QBRTCSessionTypes.AUDIO);
              setState(() {
                _videoCall = false;
              });
            },
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('hangUp'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: hangUpWebRTC,
          ),
          MaterialButton(
              minWidth: 200,
              child: Text('disable video'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                enableVideo(false);
              }),
          MaterialButton(
              minWidth: 200,
              child: Text('enable video'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                enableVideo(true);
              }),
          MaterialButton(
              minWidth: 200,
              child: Text('disable audio'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                enableAudio(false);
              }),
          MaterialButton(
              minWidth: 200,
              child: Text('enable audio'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                enableAudio(true);
              }),
          MaterialButton(
            minWidth: 200,
            child: Text('switch camera'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: switchCamera,
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('Mirror camera'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: mirrorCamera,
          ),
          Visibility(
            visible: !_videoCall,
            child: MaterialButton(
              minWidth: 200,
              child: Text('Switch audio to LOUDSPEAKER'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                switchAudioOutput(QBRTCAudioOutputTypes.LOUDSPEAKER);
              },
            ),
          ),
          Visibility(
            visible: !_videoCall,
            child: MaterialButton(
              minWidth: 200,
              child: Text('Switch audio to EARSPEAKER'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                switchAudioOutput(QBRTCAudioOutputTypes.EARSPEAKER);
              },
            ),
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('subscribe RTC events'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: () {
              subscribeCall();
              subscribeCallEnd();
              subscribeReject();
              subscribeAccept();
              subscribeHangUp();
              subscribeVideoTrack();
              subscribeNotAnswer();
              subscribePeerConnection();
            },
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('unsubscribe RTC events'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: () {
              unsubscribeCall();
              unsubscribeCallEnd();
              unsubscribeReject();
              unsubscribeAccept();
              unsubscribeHangUp();
              unsubscribeVideoTrack();
              unsubscribeNotAnswer();
              unsubscribePeerConnection();
            },
          ),
          MaterialButton(
              minWidth: 200,
              child: Text('set RTCConfigs'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                setRTCConfigs();
              }),
          MaterialButton(
              minWidth: 200,
              child: Text('get RTCConfigs'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                getRTCConfigs();
              }),
          Container(
            margin: EdgeInsets.only(
                left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
            height: 1,
            width: double.maxFinite,
            color: Colors.grey,
          ),
          Visibility(
            visible: _videoCall,
            child: new OrientationBuilder(builder: (context, orientation) {
              return new Container(
                decoration: new BoxDecoration(color: Colors.white),
                child: new Stack(
                  children: <Widget>[
                    new Align(
                      alignment: orientation == Orientation.landscape
                          ? const FractionalOffset(0.5, 0.1)
                          : const FractionalOffset(0.0, 0.5),
                      child: new Container(
                        margin: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                        width: 160.0,
                        height: 160.0,
                        child: RTCVideoView(
                          onVideoViewCreated: _onLocalVideoViewCreated,
                        ),
                        decoration: new BoxDecoration(color: Colors.black54),
                      ),
                    ),
                    new Align(
                      alignment: orientation == Orientation.landscape
                          ? const FractionalOffset(0.5, 0.5)
                          : const FractionalOffset(1.0, 0.5),
                      child: new Container(
                        margin: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                        width: 160.0,
                        height: 160.0,
                        child: RTCVideoView(
                          onVideoViewCreated: _onRemoteVideoViewCreated,
                        ),
                        decoration: new BoxDecoration(color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ]))));
  }

  void _onLocalVideoViewCreated(RTCVideoViewController controller) {
    _localVideoViewController = controller;
  }

  void _onRemoteVideoViewCreated(RTCVideoViewController controller) {
    _remoteVideoViewController = controller;
  }

  Future<void> init() async {
    try {
      await QB.webrtc.init();
      SnackBarUtils.showResult(_scaffoldKey, "WebRTC was initiated");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> setRTCConfigs() async {
    try {
      await QB.rtcConfig.setAnswerTimeInterval(10);
      await QB.rtcConfig.setDialingTimeInterval(15);
      SnackBarUtils.showResult(_scaffoldKey, "RTCConfig was set success");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> getRTCConfigs() async {
    try {
      int answerInterval = await QB.rtcConfig.getAnswerTimeInterval();
      int dialingInterval = await QB.rtcConfig.getDialingTimeInterval();
      SnackBarUtils.showResult(_scaffoldKey,
          "RTCConfig was loaded success  \n Answer Interval: $answerInterval \n Dialing Interval: $dialingInterval");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> releaseWebRTC() async {
    try {
      await QB.webrtc.release();
      SnackBarUtils.showResult(_scaffoldKey, "WebRTC was released");
      _sessionId = null;
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> releaseVideoViews() async {
    try {
      await _localVideoViewController.release();
      await _remoteVideoViewController.release();
      SnackBarUtils.showResult(_scaffoldKey, "Video Views were released");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> getSessionWebRTC() async {
    try {
      QBRTCSession session = await QB.webrtc.getSession(_sessionId);
      _sessionId = session.id;
      SnackBarUtils.showResult(
          _scaffoldKey, "The session with id $_sessionId was loaded");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> callWebRTC(int sessionType) async {
    try {
      QBRTCSession session = await QB.webrtc.call(OPPONENTS_IDS, sessionType);
      _sessionId = session.id;
      SnackBarUtils.showResult(
          _scaffoldKey, "The call was initiated for session id: $_sessionId");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> acceptWebRTC(String sessionId) async {
    try {
      QBRTCSession session = await QB.webrtc.accept(sessionId);
      String receivedSessionId = session.id;
      SnackBarUtils.showResult(
          _scaffoldKey, "Session with id: $receivedSessionId was accepted");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> rejectWebRTC(String sessionId) async {
    try {
      QBRTCSession session = await QB.webrtc.reject(sessionId);
      SnackBarUtils.showResult(
          _scaffoldKey, "Session with id: $_sessionId was rejected");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> hangUpWebRTC() async {
    try {
      QBRTCSession session = await QB.webrtc.hangUp(_sessionId);
      SnackBarUtils.showResult(
          _scaffoldKey, "Session with id: $_sessionId was hang up");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> enableVideo(bool enable) async {
    try {
      await QB.webrtc.enableVideo(_sessionId, enable: enable);
      SnackBarUtils.showResult(_scaffoldKey, "The video was enable $enable");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> enableAudio(bool enable) async {
    try {
      await QB.webrtc.enableAudio(_sessionId, enable: enable);
      SnackBarUtils.showResult(_scaffoldKey, "The audio was enable $enable");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> switchCamera() async {
    try {
      await QB.webrtc.switchCamera(_sessionId);
      SnackBarUtils.showResult(_scaffoldKey, "Camera was switched");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> mirrorCamera() async {
    try {
      await QB.webrtc.mirrorCamera(LOGGED_USER_ID, true);
      SnackBarUtils.showResult(_scaffoldKey, "Camera was switched");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> switchAudioOutput(int output) async {
    try {
      await QB.webrtc.switchAudioOutput(output);
      SnackBarUtils.showResult(_scaffoldKey, "Audio was switched");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  String parseState(int state) {
    String parsedState = "";

    switch (state) {
      case QBRTCPeerConnectionStates.NEW:
        parsedState = "NEW";
        break;
      case QBRTCPeerConnectionStates.FAILED:
        parsedState = "FAILED";
        break;
      case QBRTCPeerConnectionStates.DISCONNECTED:
        parsedState = "DISCONNECTED";
        break;
      case QBRTCPeerConnectionStates.CLOSED:
        parsedState = "CLOSED";
        break;
      case QBRTCPeerConnectionStates.CONNECTED:
        parsedState = "CONNECTED";
        break;
    }

    return parsedState;
  }

  Future<void> startRenderingLocal() async {
    try {
      await _localVideoViewController.play(_sessionId, LOGGED_USER_ID);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> startRenderingRemote(int opponentId) async {
    try {
      await _remoteVideoViewController.play(_sessionId, opponentId);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> subscribeCall() async {
    if (_callSubscription != null) {
      SnackBarUtils.showResult(_scaffoldKey,
          "You already have a subscription for: " + QBRTCEventTypes.CALL);
      return;
    }

    try {
      _callSubscription =
          await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.CALL, (data) {
        Map<String, Object> payloadMap =
            new Map<String, Object>.from(data["payload"]);

        Map<String, Object> sessionMap =
            new Map<String, Object>.from(payloadMap["session"]);

        String sessionId = sessionMap["id"];
        int initiatorId = sessionMap["initiatorId"];
        int callType = sessionMap["type"];

        setState(() {
          if (callType == QBRTCSessionTypes.AUDIO) {
            _videoCall = false;
          } else {
            _videoCall = true;
          }
        });

        _sessionId = sessionId;
        String messageCallType = _videoCall ? "Video" : "Audio";

        DialogUtils.showTwoBtn(context,
            "The INCOMING $messageCallType call from user $initiatorId",
            (accept) {
          acceptWebRTC(sessionId);
        }, (decline) {
          rejectWebRTC(sessionId);
        });
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBRTCEventTypes.CALL);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> subscribeCallEnd() async {
    if (_callEndSubscription != null) {
      SnackBarUtils.showResult(_scaffoldKey,
          "You already have a subscription for: " + QBRTCEventTypes.CALL_END);
      return;
    }
    try {
      _callEndSubscription =
          await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.CALL_END, (data) {
        Map<String, Object> payloadMap =
            new Map<String, Object>.from(data["payload"]);

        Map<String, Object> sessionMap =
            new Map<String, Object>.from(payloadMap["session"]);

        String sessionId = sessionMap["id"];

        SnackBarUtils.showResult(
            _scaffoldKey, "The call with sessionId $sessionId was ended");
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBRTCEventTypes.CALL_END);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> subscribeVideoTrack() async {
    if (_videoTrackSubscription != null) {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You already have a subscription for:" +
              QBRTCEventTypes.RECEIVED_VIDEO_TRACK);
      return;
    }

    try {
      _videoTrackSubscription = await QB.webrtc
          .subscribeRTCEvent(QBRTCEventTypes.RECEIVED_VIDEO_TRACK, (data) {
        Map<String, Object> payloadMap =
            new Map<String, Object>.from(data["payload"]);

        int opponentId = payloadMap["userId"];

        if (opponentId == LOGGED_USER_ID) {
          startRenderingLocal();
        } else {
          startRenderingRemote(opponentId);
        }
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBRTCEventTypes.RECEIVED_VIDEO_TRACK);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> subscribeNotAnswer() async {
    if (_notAnswerSubscription != null) {
      SnackBarUtils.showResult(_scaffoldKey,
          "You already have a subscription for: " + QBRTCEventTypes.NOT_ANSWER);
      return;
    }

    try {
      _notAnswerSubscription =
          await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.NOT_ANSWER, (data) {
        int userId = data["payload"]["userId"];
        DialogUtils.showOneBtn(context, "The user $userId is not answer");
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBRTCEventTypes.NOT_ANSWER);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> subscribeReject() async {
    if (_rejectSubscription != null) {
      SnackBarUtils.showResult(_scaffoldKey,
          "You already have a subscription for: " + QBRTCEventTypes.REJECT);
      return;
    }

    try {
      _rejectSubscription =
          await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.REJECT, (data) {
        int userId = data["payload"]["userId"];
        DialogUtils.showOneBtn(
            context, "The user $userId was rejected your call");
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBRTCEventTypes.REJECT);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> subscribeAccept() async {
    if (_acceptSubscription != null) {
      SnackBarUtils.showResult(_scaffoldKey,
          "You already have a subscription for: " + QBRTCEventTypes.ACCEPT);
      return;
    }

    try {
      _acceptSubscription =
          await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.ACCEPT, (data) {
        int userId = data["payload"]["userId"];
        SnackBarUtils.showResult(
            _scaffoldKey, "The user $userId was accepted your call");
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBRTCEventTypes.ACCEPT);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> subscribeHangUp() async {
    if (_hangUpSubscription != null) {
      SnackBarUtils.showResult(_scaffoldKey,
          "You already have a subscription for: " + QBRTCEventTypes.HANG_UP);
      return;
    }

    try {
      _hangUpSubscription =
          await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.HANG_UP, (data) {
        int userId = data["payload"]["userId"];
        DialogUtils.showOneBtn(context, "the user $userId is hang up");
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBRTCEventTypes.HANG_UP);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> subscribePeerConnection() async {
    if (_peerConnectionSubscription != null) {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You already have a subscription for: " +
              QBRTCEventTypes.PEER_CONNECTION_STATE_CHANGED);
      return;
    }

    try {
      _peerConnectionSubscription = await QB.webrtc.subscribeRTCEvent(
          QBRTCEventTypes.PEER_CONNECTION_STATE_CHANGED, (data) {
        int state = data["payload"]["state"];
        String parsedState = parseState(state);
        SnackBarUtils.showResult(
            _scaffoldKey, "PeerConnection state: $parsedState");
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(_scaffoldKey,
          "Subscribed: " + QBRTCEventTypes.PEER_CONNECTION_STATE_CHANGED);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void unsubscribeCall() {
    if (_callSubscription != null) {
      _callSubscription.cancel();
      _callSubscription = null;
      SnackBarUtils.showResult(
          _scaffoldKey, "Unsubscribed: " + QBRTCEventTypes.CALL);
    } else {
      SnackBarUtils.showResult(_scaffoldKey,
          "You didn't have subscription for: " + QBRTCEventTypes.CALL);
    }
  }

  void unsubscribeCallEnd() {
    if (_callEndSubscription != null) {
      _callEndSubscription.cancel();
      _callEndSubscription = null;
      SnackBarUtils.showResult(
          _scaffoldKey, "Unsubscribed: " + QBRTCEventTypes.CALL_END);
    } else {
      SnackBarUtils.showResult(_scaffoldKey,
          "You didn't have subscription for: " + QBRTCEventTypes.CALL_END);
    }
  }

  void unsubscribeReject() {
    if (_rejectSubscription != null) {
      _rejectSubscription.cancel();
      _rejectSubscription = null;
      SnackBarUtils.showResult(
          _scaffoldKey, "Unsubscribed: " + QBRTCEventTypes.REJECT);
    } else {
      SnackBarUtils.showResult(_scaffoldKey,
          "You didn't have subscription for: " + QBRTCEventTypes.REJECT);
    }
  }

  void unsubscribeAccept() {
    if (_acceptSubscription != null) {
      _acceptSubscription.cancel();
      _acceptSubscription = null;
      SnackBarUtils.showResult(
          _scaffoldKey, "Unsubscribed: " + QBRTCEventTypes.ACCEPT);
    } else {
      SnackBarUtils.showResult(_scaffoldKey,
          "You didn't have subscription for: " + QBRTCEventTypes.ACCEPT);
    }
  }

  void unsubscribeHangUp() {
    if (_hangUpSubscription != null) {
      _hangUpSubscription.cancel();
      _hangUpSubscription = null;
      SnackBarUtils.showResult(
          _scaffoldKey, "Unsubscribed: " + QBRTCEventTypes.HANG_UP);
    } else {
      SnackBarUtils.showResult(_scaffoldKey,
          "You didn't have subscription for: " + QBRTCEventTypes.HANG_UP);
    }
  }

  void unsubscribeVideoTrack() {
    if (_videoTrackSubscription != null) {
      _videoTrackSubscription.cancel();
      _videoTrackSubscription = null;
      SnackBarUtils.showResult(_scaffoldKey,
          "Unsubscribed: " + QBRTCEventTypes.RECEIVED_VIDEO_TRACK);
    } else {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You didn't have subscription for: " +
              QBRTCEventTypes.RECEIVED_VIDEO_TRACK);
    }
  }

  void unsubscribeNotAnswer() {
    if (_notAnswerSubscription != null) {
      _notAnswerSubscription.cancel();
      _notAnswerSubscription = null;
      SnackBarUtils.showResult(
          _scaffoldKey, "Unsubscribed: " + QBRTCEventTypes.NOT_ANSWER);
    } else {
      SnackBarUtils.showResult(_scaffoldKey,
          "You didn't have subscription for: " + QBRTCEventTypes.NOT_ANSWER);
    }
  }

  void unsubscribePeerConnection() {
    if (_peerConnectionSubscription != null) {
      _peerConnectionSubscription.cancel();
      _peerConnectionSubscription = null;
      SnackBarUtils.showResult(_scaffoldKey,
          "Unsubscribed: " + QBRTCEventTypes.PEER_CONNECTION_STATE_CHANGED);
    } else {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You didn't have subscription for: " +
              QBRTCEventTypes.PEER_CONNECTION_STATE_CHANGED);
    }
  }
}
