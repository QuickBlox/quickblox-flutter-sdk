import 'dart:async';
import 'dart:collection';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:quickblox_sdk/models/qb_filter.dart';
import 'package:quickblox_sdk/models/qb_message.dart';
import 'package:quickblox_sdk/models/qb_sort.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quickblox_sdk_example/credentials.dart';
import 'package:quickblox_sdk_example/utils/dialog_utils.dart';
import 'package:quickblox_sdk_example/utils/snackbar_utils.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _dialogId;
  String _messageId;

  StreamSubscription _newMessageSubscription;
  StreamSubscription _systemMessageSubscription;
  StreamSubscription _deliveredMessageSubscription;
  StreamSubscription _readMessageSubscription;
  StreamSubscription _userTypingSubscription;
  StreamSubscription _userStopTypingSubscription;
  StreamSubscription _connectedSubscription;
  StreamSubscription _connectionClosedSubscription;
  StreamSubscription _reconnectionFailedSubscription;
  StreamSubscription _reconnectionSuccessSubscription;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);

    unsubscribeNewMessage();
    unsubscribeSystemMessage();
    unsubscribeDeliveredMessage();
    unsubscribeReadMessage();
    unsubscribeUserTyping();
    unsubscribeUserStopTyping();
    unsubscribeConnected();
    unsubscribeConnectionClosed();
    unsubscribeReconnectionFailed();
    unsubscribeReconnectionSuccess();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Chat'),
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
              onPressed: connect,
              child: Text('connect'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white),
          MaterialButton(
              minWidth: 200,
              onPressed: disconnect,
              child: Text('disconnect'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white),
          MaterialButton(
              minWidth: 200,
              onPressed: isConnected,
              child: Text('is connected'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white),
          MaterialButton(
              minWidth: 200,
              onPressed: pingServer,
              child: Text('ping server'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white),
          MaterialButton(
              minWidth: 200,
              onPressed: pingUser,
              child: Text('ping user'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white),
          MaterialButton(
              minWidth: 200,
              onPressed: getDialogs,
              child: Text('get dialogs'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white),
          MaterialButton(
              minWidth: 200,
              onPressed: getDialogsCount,
              child: Text('get dialogs count'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white),
          MaterialButton(
              minWidth: 200,
              onPressed: updateDialog,
              child: Text('update dialog'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white),
          MaterialButton(
              minWidth: 200,
              onPressed: createDialog,
              child: Text('create dialog'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white),
          MaterialButton(
              minWidth: 200,
              onPressed: deleteDialog,
              child: Text('delete dialog'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white),
          MaterialButton(
              minWidth: 200,
              onPressed: leaveDialog,
              child: Text('leave dialog'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white),
          MaterialButton(
              minWidth: 200,
              onPressed: joinDialog,
              child: Text('join dialog'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white),
          MaterialButton(
              minWidth: 200,
              onPressed: getOnlineUsers,
              child: Text('get online users'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white),
          MaterialButton(
              minWidth: 200,
              onPressed: sendMessage,
              child: Text('send message'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white),
          MaterialButton(
              minWidth: 200,
              onPressed: sendSystemMessage,
              child: Text('send system message'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white),
          MaterialButton(
              minWidth: 200,
              onPressed: () {
                subscribeNewMessage();
                subscribeSystemMessage();
              },
              child: Text('subscribe message events'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white),
          MaterialButton(
              minWidth: 200,
              onPressed: () {
                unsubscribeNewMessage();
                unsubscribeSystemMessage();
              },
              child: Text('unsubscribe message events'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white),
          MaterialButton(
              minWidth: 200,
              onPressed: markMessageRead,
              child: Text('mark message read'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white),
          MaterialButton(
              minWidth: 200,
              onPressed: markMessageDelivered,
              child: Text('mark message delivered'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white),
          MaterialButton(
              minWidth: 200,
              onPressed: () {
                subscribeMessageDelivered();
                subscribeMessageRead();
              },
              child: Text('subscribe message status'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white),
          MaterialButton(
              minWidth: 200,
              onPressed: () {
                unsubscribeDeliveredMessage();
                unsubscribeReadMessage();
              },
              child: Text('unsubscribe message status'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white),
          MaterialButton(
              minWidth: 200,
              onPressed: sendIsTyping,
              child: Text('send is typing'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white),
          MaterialButton(
              minWidth: 200,
              onPressed: sendStoppedTyping,
              child: Text('send stopped typing'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white),
          MaterialButton(
              minWidth: 200,
              onPressed: () {
                subscribeUserTyping();
                subscribeUserStopTyping();
              },
              child: Text('subscribe typing'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white),
          MaterialButton(
              minWidth: 200,
              onPressed: () {
                unsubscribeUserTyping();
                unsubscribeUserStopTyping();
              },
              child: Text('unsubscribe typing'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white),
          MaterialButton(
              minWidth: 200,
              onPressed: getDialogMessages,
              child: Text('get dialog messages'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white),
          MaterialButton(
              minWidth: 200,
              onPressed: () {
                subscribeConnected();
                subscribeConnectionClosed();
                subscribeReconnectionFailed();
                subscribeReconnectionSuccess();
              },
              child: Text('subscribe event connections'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white),
          MaterialButton(
              minWidth: 200,
              onPressed: () {
                unsubscribeConnected();
                unsubscribeConnectionClosed();
                unsubscribeReconnectionFailed();
                unsubscribeReconnectionSuccess();
              },
              child: Text('unsubscribe event connections'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white),
        ]))));
  }

  void connect() async {
    try {
      await QB.chat.connect(LOGGED_USER_ID, USER_PASSWORD);
      SnackBarUtils.showResult(_scaffoldKey, "The chat was connected");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void disconnect() async {
    try {
      await QB.chat.disconnect();
      SnackBarUtils.showResult(_scaffoldKey, "The chat was disconnected");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void isConnected() async {
    try {
      bool connected = await QB.chat.isConnected();
      SnackBarUtils.showResult(
          _scaffoldKey, "The Chat connected: " + connected.toString());
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void pingServer() async {
    try {
      await QB.chat.pingServer();
      SnackBarUtils.showResult(_scaffoldKey, "The server was ping success");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void pingUser() async {
    try {
      await QB.chat.pingUser(OPPONENT_ID);
      SnackBarUtils.showResult(
          _scaffoldKey, "The user $OPPONENT_ID was ping success");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void getDialogs() async {
    try {
      QBSort sort = QBSort();
      sort.field = QBChatDialogSorts.LAST_MESSAGE_DATE_SENT;
      sort.ascending = true;

      QBFilter filter = QBFilter();
      filter.field = QBChatDialogFilterFields.LAST_MESSAGE_DATE_SENT;
      filter.operator = QBChatDialogFilterOperators.ALL;
      filter.value = "";

      int limit = 100;
      int skip = 0;

      List<QBDialog> dialogs = await QB.chat.getDialogs(
          /*sort: sort, filter: filter, limit: limit, skip: skip*/);
      var dialogsLength = dialogs.length;
      SnackBarUtils.showResult(
          _scaffoldKey, "The $dialogsLength dialogs were loaded success");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void getDialogsCount() async {
    try {
      QBFilter filter = QBFilter();
      filter.field = QBChatDialogFilterFields.LAST_MESSAGE_DATE_SENT;
      filter.operator = QBChatDialogFilterOperators.ALL;
      filter.value = "";

      int limit = 100;
      int skip = 0;

      var dialogsCount = await QB.chat
          .getDialogsCount(qbFilter: filter, limit: limit, skip: skip);
      SnackBarUtils.showResult(
          _scaffoldKey, "The dialogs count is: $dialogsCount");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void updateDialog() async {
    try {
      String dialogName = "FLUTTER_CHAT_updated_dialog";
      List<int> addUsers = new List();
      List<int> removeUsers = new List();

      QBDialog updatedDialog = await QB.chat.updateDialog(_dialogId,
          addUsers: addUsers, removeUsers: removeUsers, dialogName: dialogName);

      String updatedDialogId = updatedDialog.id;
      SnackBarUtils.showResult(
          _scaffoldKey, "The dialog $updatedDialogId was updated");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void createDialog() async {
    List<int> occupantsIds = List.from(OPPONENTS_IDS);
    String dialogName =
        "FLUTTER_CHAT_" + new DateTime.now().millisecond.toString();

    int dialogType = QBChatDialogTypes.PUBLIC_CHAT;

    try {
      QBDialog createdDialog = await QB.chat
          .createDialog(occupantsIds, dialogName, dialogType: dialogType);
      _dialogId = createdDialog.id;
      SnackBarUtils.showResult(
          _scaffoldKey, "The dialog $_dialogId was created");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void deleteDialog() async {
    try {
      await QB.chat.deleteDialog(_dialogId);
      SnackBarUtils.showResult(
          _scaffoldKey, "The dialog $_dialogId was deleted");
      _dialogId = null;
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void leaveDialog() async {
    try {
      await QB.chat.leaveDialog(_dialogId);
      SnackBarUtils.showResult(
          _scaffoldKey, "The dialog $_dialogId was leaved");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void joinDialog() async {
    try {
      await QB.chat.joinDialog(_dialogId);
      SnackBarUtils.showResult(
          _scaffoldKey, "The dialog $_dialogId was joined");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void getOnlineUsers() async {
    try {
      List<dynamic> onlineUsers = await QB.chat.getOnlineUsers(_dialogId);
      SnackBarUtils.showResult(
          _scaffoldKey, "The online users are: $onlineUsers");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void sendMessage() async {
    String messageBody =
        "Hello from flutter!" + "\n From user: " + LOGGED_USER_ID.toString();

    try {
      await QB.chat
          .sendMessage(_dialogId, body: messageBody, saveToHistory: true);
      SnackBarUtils.showResult(
          _scaffoldKey, "The message was sent to dialog: $_dialogId");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void sendSystemMessage() async {
    try {
      await QB.chat.sendSystemMessage(OPPONENT_ID);
      SnackBarUtils.showResult(_scaffoldKey, "The system message was sent");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void subscribeNewMessage() async {
    if (_newMessageSubscription != null) {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You already have a subscription for: " +
              QBChatEvents.RECEIVED_NEW_MESSAGE);
      return;
    }
    try {
      _newMessageSubscription = await QB.chat
          .subscribeChatEvent(QBChatEvents.RECEIVED_NEW_MESSAGE, (data) {
        Map<String, Object> map = new Map<String, dynamic>.from(data);

        Map<String, Object> payload =
            new Map<String, dynamic>.from(map["payload"]);
        _messageId = payload["id"];

        SnackBarUtils.showResult(
            _scaffoldKey, "Received new message: \n ${payload["body"]}");
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBChatEvents.RECEIVED_NEW_MESSAGE);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void subscribeSystemMessage() async {
    if (_systemMessageSubscription != null) {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You already have a subscription for: " +
              QBChatEvents.RECEIVED_SYSTEM_MESSAGE);
      return;
    }
    try {
      _systemMessageSubscription = await QB.chat
          .subscribeChatEvent(QBChatEvents.RECEIVED_SYSTEM_MESSAGE, (data) {
        Map<String, Object> map = new Map<String, dynamic>.from(data);

        Map<String, Object> payload =
            new Map<String, dynamic>.from(map["payload"]);
        _messageId = payload["id"];

        SnackBarUtils.showResult(_scaffoldKey, "Received system message");
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBChatEvents.RECEIVED_SYSTEM_MESSAGE);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void unsubscribeNewMessage() {
    if (_newMessageSubscription != null) {
      _newMessageSubscription.cancel();
      _newMessageSubscription = null;
      SnackBarUtils.showResult(
          _scaffoldKey, "Unsubscribed: " + QBChatEvents.RECEIVED_NEW_MESSAGE);
    } else {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You didn't have subscription for: " +
              QBChatEvents.RECEIVED_NEW_MESSAGE);
    }
  }

  void unsubscribeSystemMessage() {
    if (_systemMessageSubscription != null) {
      _systemMessageSubscription.cancel();
      _systemMessageSubscription = null;
      SnackBarUtils.showResult(_scaffoldKey,
          "Unsubscribed: " + QBChatEvents.RECEIVED_SYSTEM_MESSAGE);
    } else {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You didn't have subscription for: " +
              QBChatEvents.RECEIVED_SYSTEM_MESSAGE);
    }
  }

  void markMessageRead() async {
    QBMessage qbMessage = new QBMessage();
    qbMessage.dialogId = _dialogId;
    qbMessage.id = _messageId;
    qbMessage.senderId = LOGGED_USER_ID;

    try {
      await QB.chat.markMessageRead(qbMessage);
      SnackBarUtils.showResult(
          _scaffoldKey, "The message " + _messageId + " was marked read");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void markMessageDelivered() async {
    QBMessage qbMessage = new QBMessage();
    qbMessage.dialogId = _dialogId;
    qbMessage.id = _messageId;
    qbMessage.senderId = LOGGED_USER_ID;

    try {
      await QB.chat.markMessageDelivered(qbMessage);
      SnackBarUtils.showResult(
          _scaffoldKey, "The message " + _messageId + " was marked delivered");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void subscribeMessageDelivered() async {
    if (_deliveredMessageSubscription != null) {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You already have a subscription for: " +
              QBChatEvents.MESSAGE_DELIVERED);
      return;
    }
    try {
      _deliveredMessageSubscription =
          await QB.chat.subscribeChatEvent(QBChatEvents.MESSAGE_DELIVERED, (data) {
        LinkedHashMap<dynamic, dynamic> messageStatusHashMap = data;
        Map<String, Object> messageStatusMap =
            new Map<String, Object>.from(messageStatusHashMap);
        Map<String, Object> payloadMap =
            new Map<String, Object>.from(messageStatusHashMap["payload"]);

        String messageId = payloadMap["messageId"];
        String userId = payloadMap["userId"];
        String statusType = messageStatusMap["type"];

        SnackBarUtils.showResult(
            _scaffoldKey,
            "Received message status: $statusType \n From userId: $userId "
            "\n messageId: $messageId");
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBChatEvents.MESSAGE_DELIVERED);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void subscribeMessageRead() async {
    if (_readMessageSubscription != null) {
      SnackBarUtils.showResult(_scaffoldKey,
          "You already have a subscription for: " + QBChatEvents.MESSAGE_READ);
      return;
    }
    try {
      _readMessageSubscription =
          await QB.chat.subscribeChatEvent(QBChatEvents.MESSAGE_READ, (data) {
        LinkedHashMap<dynamic, dynamic> messageStatusHashMap = data;
        Map<String, Object> messageStatusMap =
            new Map<String, Object>.from(messageStatusHashMap);
        Map<String, Object> payloadMap =
            new Map<String, Object>.from(messageStatusHashMap["payload"]);

        String messageId = payloadMap["messageId"];
        String userId = payloadMap["userId"];
        String statusType = messageStatusMap["type"];

        SnackBarUtils.showResult(
            _scaffoldKey,
            "Received message status: $statusType \n From userId: $userId "
            "\n messageId: $messageId");
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBChatEvents.MESSAGE_READ);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void unsubscribeDeliveredMessage() async {
    if (_deliveredMessageSubscription != null) {
      _deliveredMessageSubscription.cancel();
      _deliveredMessageSubscription = null;
      SnackBarUtils.showResult(
          _scaffoldKey, "Unsubscribed: " + QBChatEvents.MESSAGE_DELIVERED);
    } else {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You didn't have subscription for: " +
              QBChatEvents.MESSAGE_DELIVERED);
    }
  }

  void unsubscribeReadMessage() async {
    if (_readMessageSubscription != null) {
      _readMessageSubscription.cancel();
      _readMessageSubscription = null;
      SnackBarUtils.showResult(
          _scaffoldKey, "Unsubscribed: " + QBChatEvents.MESSAGE_READ);
    } else {
      SnackBarUtils.showResult(_scaffoldKey,
          "You didn't have subscription for: " + QBChatEvents.MESSAGE_READ);
    }
  }

  void sendIsTyping() async {
    try {
      await QB.chat.sendIsTyping(_dialogId);
      SnackBarUtils.showResult(
          _scaffoldKey, "Sent is typing for dialog: " + _dialogId);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void sendStoppedTyping() async {
    try {
      await QB.chat.sendStoppedTyping(_dialogId);
      SnackBarUtils.showResult(
          _scaffoldKey, "Sent stopped typing for dialog: " + _dialogId);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void subscribeUserTyping() async {
    if (_userTypingSubscription != null) {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You already have a subscription for: " +
              QBChatEvents.USER_IS_TYPING);
      return;
    }
    try {
      _userTypingSubscription =
          await QB.chat.subscribeChatEvent(QBChatEvents.USER_IS_TYPING, (data) {
        Map<String, Object> map = new Map<String, dynamic>.from(data);
        Map<String, Object> payload =
            new Map<String, dynamic>.from(map["payload"]);
        int userId = payload["userId"];
        SnackBarUtils.showResult(
            _scaffoldKey, "Typing user: " + userId.toString());
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBChatEvents.USER_IS_TYPING);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void subscribeUserStopTyping() async {
    if (_userStopTypingSubscription != null) {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You already have a subscription for: " +
              QBChatEvents.USER_STOPPED_TYPING);
      return;
    }
    try {
      _userStopTypingSubscription = await QB.chat
          .subscribeChatEvent(QBChatEvents.USER_STOPPED_TYPING, (data) {
        Map<String, Object> map = new Map<String, dynamic>.from(data);
        Map<String, Object> payload =
            new Map<String, dynamic>.from(map["payload"]);
        int userId = payload["userId"];
        SnackBarUtils.showResult(
            _scaffoldKey, "Stopped typing user: " + userId.toString());
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBChatEvents.USER_STOPPED_TYPING);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void unsubscribeUserTyping() async {
    if (_userTypingSubscription != null) {
      _userTypingSubscription.cancel();
      _userTypingSubscription = null;
      SnackBarUtils.showResult(
          _scaffoldKey, "Unsubscribed: " + QBChatEvents.USER_IS_TYPING);
    } else {
      SnackBarUtils.showResult(_scaffoldKey,
          "You didn't have subscription for: " + QBChatEvents.USER_IS_TYPING);
    }
  }

  void unsubscribeUserStopTyping() async {
    if (_userStopTypingSubscription != null) {
      _userStopTypingSubscription.cancel();
      _userStopTypingSubscription = null;
      SnackBarUtils.showResult(
          _scaffoldKey, "Unsubscribed: " + QBChatEvents.USER_STOPPED_TYPING);
    } else {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You didn't have subscription for: " +
              QBChatEvents.USER_STOPPED_TYPING);
    }
  }

  void getDialogMessages() async {
    try {
      List<QBMessage> messages = await QB.chat.getDialogMessages(_dialogId);
      int countMessages = messages.asMap().length;
      SnackBarUtils.showResult(
          _scaffoldKey, "Loaded messages: " + countMessages.toString());
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void subscribeConnected() async {
    if (_connectedSubscription != null) {
      SnackBarUtils.showResult(_scaffoldKey,
          "You already have a subscription for: " + QBChatEvents.CONNECTED);
      return;
    }
    try {
      _connectedSubscription =
          await QB.chat.subscribeChatEvent(QBChatEvents.CONNECTED, (data) {
        SnackBarUtils.showResult(
            _scaffoldKey, "Received: " + QBChatEvents.CONNECTED);
      }, onErrorMethod: (error) {
        SnackBarUtils.showResult(_scaffoldKey, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBChatEvents.CONNECTED);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void subscribeConnectionClosed() async {
    if (_connectionClosedSubscription != null) {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You already have a subscription for: " +
              QBChatEvents.CONNECTION_CLOSED);
      return;
    }
    try {
      _connectionClosedSubscription =
          await QB.chat.subscribeChatEvent(QBChatEvents.CONNECTION_CLOSED, (data) {
        SnackBarUtils.showResult(
            _scaffoldKey, "Received: " + QBChatEvents.CONNECTION_CLOSED);
      }, onErrorMethod: (error) {
        SnackBarUtils.showResult(_scaffoldKey, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBChatEvents.CONNECTION_CLOSED);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void subscribeReconnectionFailed() async {
    if (_reconnectionFailedSubscription != null) {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You already have a subscription for: " +
              QBChatEvents.RECONNECTION_FAILED);
      return;
    }
    try {
      _reconnectionFailedSubscription = await QB.chat
          .subscribeChatEvent(QBChatEvents.RECONNECTION_FAILED, (data) {
        SnackBarUtils.showResult(
            _scaffoldKey, "Received: " + QBChatEvents.RECONNECTION_FAILED);
      }, onErrorMethod: (error) {
        SnackBarUtils.showResult(_scaffoldKey, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBChatEvents.RECONNECTION_FAILED);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void subscribeReconnectionSuccess() async {
    if (_reconnectionSuccessSubscription != null) {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You already have a subscription for: " +
              QBChatEvents.RECONNECTION_SUCCESSFUL);
      return;
    }
    try {
      _reconnectionSuccessSubscription = await QB.chat
          .subscribeChatEvent(QBChatEvents.RECONNECTION_SUCCESSFUL, (data) {
        SnackBarUtils.showResult(
            _scaffoldKey, "Received: " + QBChatEvents.RECONNECTION_SUCCESSFUL);
      }, onErrorMethod: (error) {
        SnackBarUtils.showResult(_scaffoldKey, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBChatEvents.RECONNECTION_SUCCESSFUL);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  void unsubscribeConnected() {
    if (_connectedSubscription != null) {
      _connectedSubscription.cancel();
      _connectedSubscription = null;
      SnackBarUtils.showResult(
          _scaffoldKey, "Unsubscribed: " + QBChatEvents.CONNECTED);
    } else {
      SnackBarUtils.showResult(_scaffoldKey,
          "You didn't have subscription for: " + QBChatEvents.CONNECTED);
    }
  }

  void unsubscribeConnectionClosed() {
    if (_connectionClosedSubscription != null) {
      _connectionClosedSubscription.cancel();
      _connectionClosedSubscription = null;
      SnackBarUtils.showResult(
          _scaffoldKey, "Unsubscribed: " + QBChatEvents.CONNECTION_CLOSED);
    } else {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You didn't have subscription for: " +
              QBChatEvents.CONNECTION_CLOSED);
    }
  }

  void unsubscribeReconnectionFailed() {
    if (_reconnectionFailedSubscription != null) {
      _reconnectionFailedSubscription.cancel();
      _reconnectionFailedSubscription = null;
      SnackBarUtils.showResult(
          _scaffoldKey, "Unsubscribed: " + QBChatEvents.RECONNECTION_FAILED);
    } else {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You didn't have subscription for: " +
              QBChatEvents.RECONNECTION_FAILED);
    }
  }

  void unsubscribeReconnectionSuccess() {
    if (_reconnectionSuccessSubscription != null) {
      _reconnectionSuccessSubscription.cancel();
      _reconnectionSuccessSubscription = null;
      SnackBarUtils.showResult(_scaffoldKey,
          "Unsubscribed: " + QBChatEvents.RECONNECTION_SUCCESSFUL);
    } else {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You didn't have subscription for: " +
              QBChatEvents.RECONNECTION_SUCCESSFUL);
    }
  }
}
