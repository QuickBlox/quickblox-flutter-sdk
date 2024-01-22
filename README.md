<div align="center">

<p>
		<a href="https://discord.gg/c6bxq9BC"><img src="https://img.shields.io/discord/1042743094833065985?color=5865F2&logo=discord&logoColor=white&label=QuickBlox%20Discord%20server&style=for-the-badge" alt="Discord server" /></a>
</p>

</div>

# Quickblox Flutter  SDK

## Quick Start
This guide demonstarates how to connect Quickblox Flutter SDK to your project and start development.

Documentation: https://docs.quickblox.com/docs/flutter-quick-start

pub.dev package: https://pub.dev/packages/quickblox_sdk

### Create a new app in the Admin Panel
Quickblox application includes everything that brings messaging right into your application - chat, video calling, users, push notifications, etc. To create a QuickBlox application, follow the steps below:

1. Register a new account. Type in your email and password to sign in. You can also sign in with your Google or Github accounts. 
2. Create the app clicking **New app** button. 
3. Configure the app. Type in the information about your organization into corresponding fields and click **Add** button.
4. Go to the screen with credentials. Locate **Credentials** groupbox and copy your **Application ID**, **Authorization Key**, and **Authorization Secret**. These data are needed to run your application on QuickBlox server.

### Install Flutter SDK into your app

To create a new Flutter chat messaging app with QuickBlox SDK from scratch follow these steps:
1. Install [Flutter](https://flutter.dev/docs/get-started/install) for your platform
2. Run `flutter create myapp` to create a new project
4. Add QuickBlox SDK into your project's dependencies into **dependencies** section in \**pubspec.yaml*\* file in your root project dir.  

`
dependencies:
quickblox_sdk: 0.13.0
`

### Send your first message
#### Initialize QuickBlox SDK

Initialize the framework with your application credentials. Pass `appId`, `authKey`, `authSecret`, `accountKey` to the `QB.settings.init` method using the code snippet below. As a result, your application details are stored in the server database and can be subsequently identified on the server. 

```dart
const String APP_ID = "XXXXX";
const String AUTH_KEY = "XXXXXXXXXXXX";
const String AUTH_SECRET = "XXXXXXXXXXXX";
const String ACCOUNT_KEY = "XXXXXXXXXXXX";
const String API_ENDPOINT = ""; //optional
const String CHAT_ENDPOINT = ""; //optional

try {
      await QB.settings.init(APP_ID, AUTH_KEY, AUTH_SECRET, ACCOUNT_KEY,
          apiEndpoint: API_ENDPOINT, chatEndpoint: CHAT_ENDPOINT);
    } on PlatformException catch (e) {
        // Some error occured, look at the exception message for more details 
    }
```

#### Authorize user

In order to use the abilities of QuickBlox SDK, you need to authorize your app on the server, log in to your account and create a session. To get it all done call `QB.auth.login` method and pass `login` and `password` parameters to it using the code snippet below. 

```dart
try {
      QBLoginResult result = await QB.auth.login(login, password);
      QBUser qbUser = result.qbUser;
      QBSession qbSession = result.qbSession;
    } on PlatformException catch (e) {
         // Some error occured, look at the exception message for more details     
    }
```    
**Note!**
You must initialize SDK before calling any methods through the SDK except for the method initializing your QuickBlox instance. If you attempt to call a method without connecting, the error is returned.

#### Connect to chat

To connect to chat server, use the code snippet below:

```dart
try {
      await QB.chat.connect(userId, userPassword);
     } on PlatformException catch (e) {
          // Some error occured, look at the exception message for more details     
     }
```

#### Create dialog

QuickBlox provides three types of dialogs: **1-1 dialog**, **group dialog**, and **public dialog**.

Let’s create **1-1 dialog**. Call `QB.chat.createDialog` method and pass `QBChatDialogTypes.CHAT` parameter as a dialog type to it. `QBChatDialogTypes.CHAT` parameter allows specifying that two occupants are going to participate in the dialog.

```dart
try {
      QBDialog createdDialog = await QB.chat.createDialog(occupantsIds, dialogName, dialogType: dialogType);
      } on PlatformException catch (e) {
           // Some error occured, look at the exception message for more details     
      }
```      

#### Subscribe to receive messages

QuickBlox provides chat event handler allowing to notify client apps of events that happen on the chat. Thus, when a dialog has been created, a user can subscribe to receive notifications about new incoming messages. To subscribe to message events call `QB.chat.subscribeChatEvent` method and pass QBChatEvents.RECEIVED_NEW_MESSAGE as an event parameter to it using the following code snippet.

`event` - provides some values:

- `QBChatEvents.RECEIVED_NEW_MESSAGE` - subscribe to `new messages` event
- `QBChatEvents.RECEIVED_SYSTEM_MESSAGE` - subsccribe to `system messages` event
- `QBChatEvents.MESSAGE_DELIVERED` - subscribe to `message delivered` event
- `QBChatEvents.MESSAGE_READ` - subscribe to `message read` event

```dart

StreamSubscription? _someSubscription;

...

@override
void dispose() {
  if(_someSubscription != null) {
    _someSubscription!.cancel();
    _someSubscription = null;
  }
}

...

String event = QBChatEvents.RECEIVED_NEW_MESSAGE;

try {
  _someSubscription = await QB.chat.subscribeChatEvent(event, (data) {
        Map<dynamic, dynamic> map = Map<dynamic, dynamic>.from(data);
    Map<dynamic, dynamic> payload = Map<dynamic, dynamic>.from(map["payload"]);
    String? messageId = payload["id"];
  }
});
} on PlatformException catch (e) {
  // Some error occurred, look at the exception message for more details
}
```  

#### Send message

When a dialog is created, a user can send a message. To create and send your first message, call `QB.chat.sendMessage` method and specify the `dialogId` and `body` parameters to it. Pass `saveToHistory` parameter if you want this message to be saved in chat history that is stored forever.

```dart
try {
      await QB.chat.sendMessage(dialogId, body: messageBody, saveToHistory: true);
      } on PlatformException catch (e) {
          // Some error occured, look at the exception message for more details     
      }
```      

## LICENSE
For license information, please visit: https://quickblox.com/terms-of-use/
