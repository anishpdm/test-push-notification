import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");

}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyADuGQj3g--qSJWp5vrKyfBD-sT1djLxfc", // Replace with actual values
      appId: "1:536740928976:android:45b2db80b7917f7226add5",
      messagingSenderId: "536740928976",
      projectId: "fir-notifications-7a957",
    ),
  );
  runApp(MyApp());
}


// void main() {
//
//   WidgetsFlutterBinding.ensureInitialized();
//
//   runApp(AppInitializer());
//
// }

class AppInitializer extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override

  Widget build(BuildContext context) {

    return FutureBuilder(

      future: _initialization,

      builder: (context, snapshot) {

        // Check for errors

        if (snapshot.hasError) {

          return Center(child: MaterialApp(home: Scaffold(body: Text("Firebase initialization failed"))));

        }

        // Once complete, show your application

        if (snapshot.connectionState == ConnectionState.done) {

          FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

          return MyApp();

        }

        // Otherwise, show something whilst waiting for initialization to complete

        return MaterialApp(home: Scaffold(body: CircularProgressIndicator()));

      },

    );

  }

}

class MyApp extends StatelessWidget {

  @override

  Widget build(BuildContext context) {

    return MaterialApp(

      title: 'Push Notification Demo',

      home: MyHomePage(),

    );

  }

}

class MyHomePage extends StatefulWidget {

  @override

  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {

  late FirebaseMessaging _firebaseMessaging;

  @override

  void initState() {

    super.initState();

    _firebaseMessaging = FirebaseMessaging.instance;

    _requestPermissions();

    _registerOnFirebase();

    _listenToFCMTokenRefresh();

    _handleForegroundMessages();

  }

  void _requestPermissions() {

    _firebaseMessaging.requestPermission(

      alert: true,

      announcement: false,

      badge: true,

      carPlay: false,

      criticalAlert: false,

      provisional: false,

      sound: true,

    );

  }

  void _registerOnFirebase() {

    _firebaseMessaging.getToken().then((String? token) {

      assert(token != null);

      print("FCM Token: $token");

    });

  }

  void _listenToFCMTokenRefresh() {

    FirebaseMessaging.instance.onTokenRefresh.listen((String token) {

      print("FCM Token Refreshed: $token");

    });

  }

  void _handleForegroundMessages() {

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      print("Received a message in the foreground!");

    });

  }

  @override

  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text('Push Notification Demo'),

      ),

      body: Center(

        child: Text('Waiting for notifications...'),

      ),

    );

  }

}
