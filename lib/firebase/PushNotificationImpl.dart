import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:mamak/firebase_options.dart';
import 'package:mamak/presentation/viewModel/app/appViewModel.dart';

class PushNotificationImpl {
  static void invoke() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    // if (kIsWeb) {

    //   await messaging.requestPermission(
    //     alert: true,
    //     announcement: false,
    //     badge: true,
    //     carPlay: false,
    //     criticalAlert: false,
    //     provisional: false,
    //     sound: true,
    //   );

    // } else {
    //   await FirebaseMessaging.instance.setAutoInitEnabled(true);
    //   FirebaseMessaging.onBackgroundMessage(
    //       AppViewModel.firebaseMessagingBackgroundHandler);
    // }
  }
}
