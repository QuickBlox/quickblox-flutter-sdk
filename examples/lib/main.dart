import 'package:flutter/material.dart';
import 'package:quickblox_sdk_example/credentials.dart';
import 'package:quickblox_sdk_example/screens/auth_screen.dart';
import 'package:quickblox_sdk_example/screens/chat_screen.dart';
import 'package:quickblox_sdk_example/screens/content_screen.dart';
import 'package:quickblox_sdk_example/screens/custom_objects_screen.dart';
import 'package:quickblox_sdk_example/screens/events_screen.dart';
import 'package:quickblox_sdk_example/screens/settings_screen.dart';
import 'package:quickblox_sdk_example/screens/subscriptions_screen.dart';
import 'package:quickblox_sdk_example/screens/users_screen.dart';
import 'package:quickblox_sdk_example/screens/webrtc_screen.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MainScreen());
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Quickblox SDK'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(children: [
            MaterialButton(
                minWidth: 200,
                child: Text('Auth'),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => AuthScreen(),
                    ))),
            MaterialButton(
                minWidth: 200,
                child: Text('Chat'),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => ChatScreen(),
                    ))),
            MaterialButton(
                minWidth: 200,
                child: Text('Custom objects'),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => CustomObjectsScreen(),
                    ))),
            MaterialButton(
                minWidth: 200,
                child: Text('File'),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => ContentScreen(),
                    ))),
            MaterialButton(
                minWidth: 200,
                child: Text('Events'),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => EventsScreen(),
                    ))),
            MaterialButton(
                minWidth: 200,
                child: Text('Subscriptions'),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => SubscriptionsScreen(),
                    ))),
            MaterialButton(
                minWidth: 200,
                child: Text('Settings'),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => SettingsScreen(),
                    ))),
            MaterialButton(
                minWidth: 200,
                child: Text('Users'),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => UsersScreen(),
                    ))),
            MaterialButton(
                minWidth: 200,
                child: Text('WebRTC'),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => WebRTCScreen(),
                    ))),
            Padding(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Text(
                    "USER LOGIN: $USER_LOGIN \n USER ID: $LOGGED_USER_ID",
                    style: TextStyle(fontSize: 14))),
          ]),
        ));
  }
}
