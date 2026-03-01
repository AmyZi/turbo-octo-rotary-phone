
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseHelper {

  void subscribeFirebaseTopic() async{
    if (Platform.isIOS) {
      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken != null) {
        await FirebaseMessaging.instance.subscribeToTopic('customer_maintenance_mode_on');
        await FirebaseMessaging.instance.subscribeToTopic('customer_maintenance_mode_off');
        await FirebaseMessaging.instance.subscribeToTopic('customers_send_notification');
      } else {
        await Future<void>.delayed(
          const Duration(
            seconds: 3,
          ),
        );
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken != null) {
          await FirebaseMessaging.instance.subscribeToTopic('customer_maintenance_mode_on');
          await FirebaseMessaging.instance.subscribeToTopic('customer_maintenance_mode_off');
          await FirebaseMessaging.instance.subscribeToTopic('customers_send_notification');
        }
      }
    } else {
      await FirebaseMessaging.instance.subscribeToTopic('customer_maintenance_mode_on');
      await FirebaseMessaging.instance.subscribeToTopic('customer_maintenance_mode_off');
      await FirebaseMessaging.instance.subscribeToTopic('customers_send_notification');
    }
  }
}