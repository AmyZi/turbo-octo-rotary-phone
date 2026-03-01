import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/notification_helper.dart';
import 'package:ride_sharing_user_app/helper/di_container.dart' as di;
import 'package:ride_sharing_user_app/helper/route_helper.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/localization/messages.dart';
import 'package:ride_sharing_user_app/theme/dark_theme.dart';
import 'package:ride_sharing_user_app/theme/light_theme.dart';
import 'package:ride_sharing_user_app/theme/theme_controller.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if(GetPlatform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCFGqSEiWMItei_AFIUgdM53PWrvyGmjFY",
        appId: "1:76471554747:android:9fb5d198e81cd2b26d0f9e",
        messagingSenderId: "76471554747",
        projectId: "drivevalley-fdb7f",
      ),
    );
  } else {
  await Firebase.initializeApp();
  }



  Map<String, Map<String, String>> languages = await di.init();
  final RemoteMessage? remoteMessage = await FirebaseMessaging.instance.getInitialMessage();

  await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp(languages: languages, notificationData: remoteMessage?.data));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;
  final Map<String,dynamic>? notificationData;
  const MyApp({super.key, required this.languages, this.notificationData});


  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetBuilder<LocalizationController>(builder: (localizeController) {
        return SafeArea(
          top: false,
          child: GetMaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            navigatorKey: Get.key,
            scrollBehavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},),
            theme: themeController.darkTheme ? darkTheme : lightTheme,
            locale: localizeController.locale,
            initialRoute: RouteHelper.getSplashRoute(notificationData: notificationData),
            getPages: RouteHelper.routes,
            translations: Messages(languages: languages),
            fallbackLocale: Locale(AppConstants.languages[0].languageCode, AppConstants.languages[0].countryCode),
            defaultTransition: Transition.fadeIn,
            transitionDuration: const Duration(milliseconds: 500),
              builder:(context,child){
                return MediaQuery(data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(0.95)), child: child!);
              }
          ),
        );
      });
    });
  }
}

