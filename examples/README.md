# Quickblox Flutter examples SDK

## Quick Start
This guide demonstrates how to run Quickblox Flutter SDK examples.

Documentation: https://docs.quickblox.com/docs/flutter-quick-start

### Create a new app in the Admin Panel
Quickblox application includes everything that brings messaging right into your application - chat, video calling, users, push notifications, etc. To create a QuickBlox application, follow the steps below:

1. Register a new account. Type in your email and password to sign in. You can also sign in with your Google or Github accounts. 
2. Create the app clicking **New app** button. 
3. Configure the app. Type in the information about your organization into corresponding fields and click **Add** button.
4. Go to the screen with credentials. Locate **Credentials** groupbox and copy your **Application ID**, **Authorization Key**, and **Authorization Secret**. These data are needed to run your application on QuickBlox server.

### Run the examples

1. Change the dir to `lib`
2. Open and modify the `credentials.dart` file with your account data

```dart
const String APP_ID = ""; // application id from your account
const String AUTH_KEY = ""; // authentication key from your account
const String AUTH_SECRET = ""; // authentication secret key from your account
const String ACCOUNT_KEY = ""; // account key from your account
const String API_ENDPOINT = ""; // optional
const String CHAT_ENDPOINT = ""; // optional

const String USER_LOGIN = ""; // user login
const String USER_PASSWORD = ""; // user password
const int LOGGED_USER_ID = 000000000; // user id
const int OPPONENT_ID = 000000000; // uer id of opponent user

const List<int> OPPONENTS_IDS = [OPPONENT_ID];
const String DIALOG_ID = "";  // dialog id
const String CUSTOM_OBJECT_ClASS_NAME = ""; // name of custom object class
```
3. Run `flutter run` in lib directory
4. You can see the simple UI with button where you can test base functional of Quickblox SDK.

### Start the video call

1. Check permissions application
    - open the application settings
    - swipe the all permissions to enabled `Camera, Microphone, Storage`
2. Init SDK and start the call
    - open the examples application
    - Press `Settings` button
    - Press `init credentials` button and wait when will show `The credentials were set` message
    - Return to the main screen
    - Press `Auth` button
    - Press `Login` button and waiting when will show `Login success` message 
    - Return to the main screen
    - Press `Chat` button
    - Press `Connect` button and wait when will show `The chat was connected` message
    - Return to the main screen
    - Press `WebRTC` button
    - Press `init` button and wait when will show `The WebRTC was initiated` message
    - Press `subscribe RTC events`
    - Press `subscribe RTC events` and wait when messages about subscribing will stop show
    - Press `call Video` button
    - The opponent (`user with opponent id` from credentials file) will show incoming call dialog
    - Press `accept` button in opponent application and you can see the video call between two users
 
 3. Finish the video call
    - Press `hangUp` button
    - Press `release Video Views`  button
    - Press `release` button
    - Return  to the main screen

## LICENSE
For license information, please visit: https://quickblox.com/terms-of-use/