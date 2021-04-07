import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_sdk/conference/conference_video_view.dart';
import 'package:quickblox_sdk/conference/constants.dart';
import 'package:quickblox_sdk/models/qb_conference_rtc_session.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quickblox_sdk_example/credentials.dart';
import 'package:quickblox_sdk_example/utils/dialog_utils.dart';
import 'package:quickblox_sdk_example/utils/snackbar_utils.dart';

class ConferenceScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ConferenceScreenState();
}

class _ConferenceScreenState extends State<ConferenceScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _sessionId;

  ConferenceVideoViewController _localVideoViewController;
  ConferenceVideoViewController _remoteVideoViewController;

  StreamSubscription _videoTrackSubscription;
  StreamSubscription _participantReceivedSubscription;
  StreamSubscription _participantLeftSubscription;
  StreamSubscription _errorSubscription;
  StreamSubscription _conferenceClosedSubscription;
  StreamSubscription _conferenceStateChangedSubscription;

  @override
  void dispose() {
    super.dispose();

    unsubscribeVideoTrack();
    unsubscribeParticipantReceived();
    unsubscribeParticipantLeft();
    unsubscribeErrors();
    unsubscribeConferenceClosed();
    unsubscribeConferenceStateChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Conference'),
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
              child: Text('create session'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                create(QBConferenceSessionTypes.VIDEO);
              }),
          MaterialButton(
            minWidth: 200,
            child: Text('join as publisher'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: () {
              joinAsPublisher(QBConferenceSessionTypes.VIDEO);
            },
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('get online participants'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: getOnlineParticipants,
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('leave session'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: leaveSession,
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
          Visibility(
            child: MaterialButton(
              minWidth: 200,
              child: Text('Switch audio to LOUDSPEAKER'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                switchAudioOutput(QBConferenceAudioOutputTypes.LOUDSPEAKER);
              },
            ),
          ),
          Visibility(
            child: MaterialButton(
              minWidth: 200,
              child: Text('Switch audio to EARSPEAKER'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                switchAudioOutput(QBConferenceAudioOutputTypes.EARSPEAKER);
              },
            ),
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('subscribe Conference events'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: () {
              subscribeVideoTrack();
              subscribeParticipantReceived();
              subscribeParticipantLeft();
              subscribeErrors();
              subscribeConferenceClosed();
              subscribeConferenceStateChanged();
            },
          ),
          MaterialButton(
            minWidth: 200,
            child: Text('unsubscribe Conference events'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: () {
              unsubscribeVideoTrack();
              unsubscribeParticipantReceived();
              unsubscribeParticipantLeft();
              unsubscribeErrors();
              unsubscribeConferenceClosed();
              unsubscribeConferenceStateChanged();
            },
          ),
          Container(
            margin: EdgeInsets.only(
                left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
            height: 1,
            width: double.maxFinite,
            color: Colors.grey,
          ),
          Visibility(
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
                        child: ConferenceVideoView(
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
                        child: ConferenceVideoView(
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

  void _onLocalVideoViewCreated(ConferenceVideoViewController controller) {
    _localVideoViewController = controller;
  }

  void _onRemoteVideoViewCreated(ConferenceVideoViewController controller) {
    _remoteVideoViewController = controller;
  }

  Future<void> init() async {
    try {
      await QB.conference.init(JANUS_SERVER_URL);
      SnackBarUtils.showResult(_scaffoldKey, "Conference was initiated");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> releaseWebRTC() async {
    try {
      await QB.conference.release();
      SnackBarUtils.showResult(_scaffoldKey, "Conference was released");
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

  Future<void> create(int sessionType) async {
    try {
      QBConferenceRTCSession session =
          await QB.conference.create(DIALOG_ID, sessionType);

      _sessionId = session.id;

      SnackBarUtils.showResult(
          _scaffoldKey, "The session with id \n $_sessionId \n was created");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> joinAsPublisher(int sessionType) async {
    try {
      List<int> participants = await QB.conference.joinAsPublisher(_sessionId);
      for (int userId in participants) {
        subscribeToParticipant(_sessionId, userId);
      }
      SnackBarUtils.showResult(_scaffoldKey,
          "Joined to session \n $_sessionId \n with participants $participants");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> getOnlineParticipants() async {
    try {
      List<int> participants =
          await QB.conference.getOnlineParticipants(_sessionId);
      SnackBarUtils.showResult(_scaffoldKey,
          "Session \n $_sessionId has participants \n $participants");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> subscribeToParticipant(String sessionId, int userId) async {
    try {
      await QB.conference.subscribeToParticipant(sessionId, userId);
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed to $userId \n Session id: $sessionId");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> unsubscribeToParticipant(String sessionId, int userId) async {
    try {
      await QB.conference.unsubscribeToParticipant(sessionId, userId);
      SnackBarUtils.showResult(
          _scaffoldKey, "Unsubscribed to $userId \n Session id: $sessionId");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> leaveSession() async {
    try {
      await QB.conference.leave(_sessionId);
      SnackBarUtils.showResult(
          _scaffoldKey, "Session with id: \n $_sessionId \n was leaved");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> enableVideo(bool enable) async {
    try {
      await QB.conference.enableVideo(_sessionId, enable: enable);
      SnackBarUtils.showResult(_scaffoldKey, "The video was enable $enable");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> enableAudio(bool enable) async {
    try {
      await QB.conference.enableAudio(_sessionId, enable: enable);
      SnackBarUtils.showResult(_scaffoldKey, "The audio was enable $enable");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> switchCamera() async {
    try {
      await QB.conference.switchCamera(_sessionId);
      SnackBarUtils.showResult(_scaffoldKey, "Camera was switched");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> switchAudioOutput(int output) async {
    try {
      await QB.conference.switchAudioOutput(output);
      SnackBarUtils.showResult(_scaffoldKey, "Audio was switched");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
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

  Future<void> subscribeVideoTrack() async {
    if (_videoTrackSubscription != null) {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You already have a subscription:" +
              QBConferenceEventTypes.CONFERENCE_VIDEO_TRACK_RECEIVED);
      return;
    }

    try {
      _videoTrackSubscription = await QB.conference.subscribeConferenceEvent(
          QBConferenceEventTypes.CONFERENCE_VIDEO_TRACK_RECEIVED, (data) {
        Map<String, Object> payloadMap =
            new Map<String, Object>.from(data["payload"]);

        int opponentId = payloadMap["userId"];

        if (opponentId == LOGGED_USER_ID) {
          startRenderingLocal();
        } else {
          startRenderingRemote(opponentId);
        }

        SnackBarUtils.showResult(
            _scaffoldKey, "Received video track for user : $opponentId");
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey,
          "Subscribed: " +
              QBConferenceEventTypes.CONFERENCE_VIDEO_TRACK_RECEIVED);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void unsubscribeVideoTrack() {
    if (_videoTrackSubscription != null) {
      _videoTrackSubscription.cancel();
      _videoTrackSubscription = null;
      SnackBarUtils.showResult(
          _scaffoldKey,
          "Unsubscribed: " +
              QBConferenceEventTypes.CONFERENCE_VIDEO_TRACK_RECEIVED);
    } else {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You didn't have subscription for: " +
              QBConferenceEventTypes.CONFERENCE_VIDEO_TRACK_RECEIVED);
    }
  }

  void subscribeParticipantReceived() async {
    if (_participantReceivedSubscription != null) {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You already have a subscription:" +
              QBConferenceEventTypes.CONFERENCE_PARTICIPANT_RECEIVED);
      return;
    }
    try {
      _participantReceivedSubscription = await QB.conference
          .subscribeConferenceEvent(
              QBConferenceEventTypes.CONFERENCE_PARTICIPANT_RECEIVED, (data) {
        int userId = data["payload"]["userId"];
        String sessionId = data["payload"]["sessionId"];

        SnackBarUtils.showResult(_scaffoldKey,
            "Received participant: $userId \n Session id: $sessionId");

        subscribeToParticipant(sessionId, userId);
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey,
          "Subscribed: " +
              QBConferenceEventTypes.CONFERENCE_PARTICIPANT_RECEIVED);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void unsubscribeParticipantReceived() {
    if (_participantReceivedSubscription != null) {
      _participantReceivedSubscription.cancel();
      _participantReceivedSubscription = null;
      SnackBarUtils.showResult(
          _scaffoldKey,
          "Unsubscribed: " +
              QBConferenceEventTypes.CONFERENCE_PARTICIPANT_RECEIVED);
    } else {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You didn't have subscription for: " +
              QBConferenceEventTypes.CONFERENCE_PARTICIPANT_RECEIVED);
    }
  }

  void subscribeParticipantLeft() async {
    if (_participantLeftSubscription != null) {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You already have a subscription:" +
              QBConferenceEventTypes.CONFERENCE_PARTICIPANT_LEFT);
      return;
    }
    try {
      _participantLeftSubscription = await QB.conference
          .subscribeConferenceEvent(
              QBConferenceEventTypes.CONFERENCE_PARTICIPANT_LEFT, (data) {
        String sessionId = data["payload"]["sessionId"];
        int userId = data["payload"]["userId"];

        SnackBarUtils.showResult(_scaffoldKey,
            "Left participant: $userId \n Session id: $sessionId");

        unsubscribeToParticipant(sessionId, userId);
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(_scaffoldKey,
          "Subscribed: " + QBConferenceEventTypes.CONFERENCE_PARTICIPANT_LEFT);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void unsubscribeParticipantLeft() {
    if (_participantLeftSubscription != null) {
      _participantLeftSubscription.cancel();
      _participantLeftSubscription = null;
      SnackBarUtils.showResult(
          _scaffoldKey,
          "Unsubscribed: " +
              QBConferenceEventTypes.CONFERENCE_PARTICIPANT_LEFT);
    } else {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You didn't have subscription for: " +
              QBConferenceEventTypes.CONFERENCE_PARTICIPANT_LEFT);
    }
  }

  void subscribeErrors() async {
    if (_errorSubscription != null) {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You already have a subscription:" +
              QBConferenceEventTypes.CONFERENCE_ERROR_RECEIVED);
      return;
    }
    try {
      _errorSubscription = await QB.conference.subscribeConferenceEvent(
          QBConferenceEventTypes.CONFERENCE_ERROR_RECEIVED, (data) {
        String errorMessage = data["payload"]["errorMessage"];
        String sessionId = data["payload"]["sessionId"];

        SnackBarUtils.showResult(_scaffoldKey,
            "Received error: $errorMessage \n Session id: $sessionId");
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(_scaffoldKey,
          "Subscribed: " + QBConferenceEventTypes.CONFERENCE_ERROR_RECEIVED);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void unsubscribeErrors() {
    if (_errorSubscription != null) {
      _errorSubscription.cancel();
      _errorSubscription = null;
      SnackBarUtils.showResult(_scaffoldKey,
          "Unsubscribed: " + QBConferenceEventTypes.CONFERENCE_ERROR_RECEIVED);
    } else {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You didn't have subscription for: " +
              QBConferenceEventTypes.CONFERENCE_ERROR_RECEIVED);
    }
  }

  void subscribeConferenceClosed() async {
    if (_conferenceClosedSubscription != null) {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You already have a subscription:" +
              QBConferenceEventTypes.CONFERENCE_CLOSED);
      return;
    }
    try {
      _conferenceClosedSubscription = await QB.conference
          .subscribeConferenceEvent(QBConferenceEventTypes.CONFERENCE_CLOSED,
              (data) {
        String sessionId = data["payload"]["sessionId"];

        SnackBarUtils.showResult(_scaffoldKey, "Closed session: $sessionId");
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(_scaffoldKey,
          "Subscribed: " + QBConferenceEventTypes.CONFERENCE_CLOSED);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void unsubscribeConferenceClosed() {
    if (_conferenceClosedSubscription != null) {
      _conferenceClosedSubscription.cancel();
      _conferenceClosedSubscription = null;
      SnackBarUtils.showResult(_scaffoldKey,
          "Unsubscribed: " + QBConferenceEventTypes.CONFERENCE_CLOSED);
    } else {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You didn't have subscription for: " +
              QBConferenceEventTypes.CONFERENCE_CLOSED);
    }
  }

  void subscribeConferenceStateChanged() async {
    if (_conferenceStateChangedSubscription != null) {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You already have a subscription:" +
              QBConferenceEventTypes.CONFERENCE_STATE_CHANGED);
      return;
    }
    try {
      _conferenceStateChangedSubscription = await QB.conference
          .subscribeConferenceEvent(
              QBConferenceEventTypes.CONFERENCE_STATE_CHANGED, (data) {
        int state = data["payload"]["state"];
        String sessionId = data["payload"]["sessionId"];

        String parsedState = "";

        switch (state) {
          case 0:
            parsedState = "NEW";
            break;
          case 1:
            parsedState = "PENDING";
            break;
          case 2:
            parsedState = "CONNECTING";
            break;
          case 3:
            parsedState = "CONNECTED";
            break;
          case 4:
            parsedState = "CLOSED";
            break;
        }

        SnackBarUtils.showResult(_scaffoldKey,
            "Changed state to: $parsedState \n for session $sessionId");
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(_scaffoldKey,
          "Subscribed: " + QBConferenceEventTypes.CONFERENCE_STATE_CHANGED);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void unsubscribeConferenceStateChanged() {
    if (_conferenceStateChangedSubscription != null) {
      _conferenceStateChangedSubscription.cancel();
      _conferenceStateChangedSubscription = null;
      SnackBarUtils.showResult(_scaffoldKey,
          "Unsubscribed: " + QBConferenceEventTypes.CONFERENCE_STATE_CHANGED);
    } else {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You didn't have subscription for: " +
              QBConferenceEventTypes.CONFERENCE_STATE_CHANGED);
    }
  }
}
