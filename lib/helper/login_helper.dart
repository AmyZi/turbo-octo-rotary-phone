import 'dart:async';
import 'dart:io';
import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/features/auth/screens/sign_in_screen.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/location/view/access_location_screen.dart';
import 'package:ride_sharing_user_app/features/maintainance_mode/maintainance_screen.dart';
import 'package:ride_sharing_user_app/features/onboard/screens/onboarding_screen.dart';
import 'package:ride_sharing_user_app/features/payment/controllers/payment_controller.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/profile/screens/edit_profile_screen.dart';
import 'package:ride_sharing_user_app/features/refund_request/controllers/refund_request_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/features/splash/domain/models/config_model.dart';
import 'package:ride_sharing_user_app/features/splash/screens/app_version_warning_screen.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';
import 'package:ride_sharing_user_app/helper/firebase_helper.dart';
import 'package:ride_sharing_user_app/helper/notification_helper.dart';
import 'package:ride_sharing_user_app/helper/pusher_helper.dart';
import 'package:ride_sharing_user_app/localization/language_selection_screen.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class LoginHelper{
  final AppLinks _appLinks = AppLinks();
  StreamSubscription? _sub;

  LoginHelper();

  void handleIncomingLinks(Map<String,dynamic>? notificationData, String? userName) {
    Get.find<TripController>().getRideCancellationReasonList();
    Get.find<TripController>().getParcelCancellationReasonList();
    Get.find<RefundRequestController>().getParcelRefundReasonList();
    Get.find<PaymentController>().getPaymentGetWayList();
    FirebaseHelper().subscribeFirebaseTopic();

    Get.find<ConfigController>().getConfigData().then((value){


      if(_isForceUpdate(Get.find<ConfigController>().config)) {
        Get.offAll(()=> const AppVersionWarningScreen());
      }else{
        _appLinks.getInitialLink().then((Uri? uri) {
          if (uri != null) {
            _handleUri(uri, notificationData, userName);
          }else{
            _route(notificationData,userName);
            if(GetPlatform.isIOS){
              _sub = _appLinks.uriLinkStream.listen((Uri? uri) {
                if (uri != null) {
                  _handleUri(uri, notificationData, userName);
                }
              });
            }
          }
        });
      }

    });

  }


  bool _isForceUpdate(ConfigModel? config) {
    double minimumVersion = Platform.isAndroid
        ? config?.androidAppMinimumVersion ?? 0
        : Platform.isIOS
        ? config?.iosAppMinimumVersion ?? 0
        : 0;

    return minimumVersion > 0 && minimumVersion > AppConstants.appVersion;
  }


  void _handleUri(Uri uri, Map<String,dynamic>? notificationData, String? userName) {
    final String? fromMartPhone = uri.queryParameters['phone'];
    final String? fromMartPassword = uri.queryParameters['password'];
    final String? fromCountryCode = uri.queryParameters['country_code'];
    if(Get.find<AuthController>().getUserToken().isNotEmpty){
      Get.find<ProfileController>().getProfileInfo().then((value) {
        if(value.statusCode == 200) {
          Get.find<AuthController>().updateToken();
          if(Get.find<ProfileController>().profileModel?.data?.phone == '+${fromCountryCode!.trim()}$fromMartPhone'){
            _route(notificationData, userName);
          }else{
            Get.find<AuthController>().externalLogin('+${fromCountryCode.trim()}', fromMartPhone!, fromMartPassword!);
          }
        }
      });

    }else{
      Get.find<AuthController>().externalLogin('+${fromCountryCode?.trim()}', fromMartPhone ?? '', fromMartPassword ?? '');
    }
  }

  void _route(Map<String,dynamic>? notificationData, String? userName) async {

    if(Get.find<AuthController>().getUserToken().isNotEmpty){
      PusherHelper.initializePusher();
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      if(Get.find<AuthController>().isLoggedIn()) {
        if(Get.find<LocalizationController>().haveLocalLanguageCode()){
          forLoginUserRoute(notificationData, userName);
        }else{
          Get.offAll(()=> LanguageSelectionScreen(userName: userName, notificationData: notificationData));
        }

      }else{
        forNotLoginUserRoute(notificationData, userName);
      }
    });

  }

  void forNotLoginUserRoute(Map<String,dynamic>? notificationData, String? userName){
    if(Get.find<ConfigController>().config!.maintenanceMode != null &&
        Get.find<ConfigController>().config!.maintenanceMode!.maintenanceStatus == 1 &&
        Get.find<ConfigController>().config!.maintenanceMode!.selectedMaintenanceSystem!.userApp == 1
    ){
      Get.offAll(() => const MaintenanceScreen());
    }else{
      if (Get.find<ConfigController>().showIntro()) {
        Get.offAll(() => OnBoardingScreen(notificationData: notificationData, userName: userName));

      }else {
        if(Get.find<LocalizationController>().haveLocalLanguageCode()){
          Get.offAll(() => const SignInScreen());

        }else{
          Get.offAll(()=> LanguageSelectionScreen(userName: userName, notificationData: notificationData));
        }

      }
    }
  }

  void forLoginUserRoute(Map<String,dynamic>? notificationData, String? userName){
    if(notificationData != null) {
      NotificationHelper.notificationRouteCheck(notificationData, formSplash: true, userName: userName);

    }else if(Get.find<LocationController>().getUserAddress() != null
        && Get.find<LocationController>().getUserAddress()!.address != null
        && Get.find<LocationController>().getUserAddress()!.address!.isNotEmpty) {

      Get.find<ProfileController>().getProfileInfo().then((value) {
        if(value.statusCode == 200) {
          Get.find<AuthController>().updateToken();
          if(value.body['data']['is_profile_verified'] == 1) {
            Get.find<AuthController>().remainingFindingRideTime();
            Get.offAll(()=> const DashboardScreen());
          }else {
            Get.offAll(() => const EditProfileScreen(fromLogin: true));
          }
        }
      });

    }else{
      Get.offAll(() => const AccessLocationScreen());
    }
  }

  void disposeStream(){
    _sub?.cancel();
  }
}