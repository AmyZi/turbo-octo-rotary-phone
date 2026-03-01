import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:ride_sharing_user_app/features/address/domain/repositories/address_repository_interface.dart';
import 'package:ride_sharing_user_app/features/address/domain/services/address_service.dart';
import 'package:ride_sharing_user_app/features/address/domain/services/address_service_interface.dart';
import 'package:ride_sharing_user_app/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:ride_sharing_user_app/features/auth/domain/services/auth_service.dart';
import 'package:ride_sharing_user_app/features/auth/domain/services/auth_service_interface.dart';
import 'package:ride_sharing_user_app/features/coupon/domain/repositories/coupon_repository_interface.dart';
import 'package:ride_sharing_user_app/features/coupon/domain/services/coupon_service.dart';
import 'package:ride_sharing_user_app/features/coupon/domain/services/coupon_service_interface.dart';
import 'package:ride_sharing_user_app/features/home/domain/repositories/category_repo.dart';
import 'package:ride_sharing_user_app/features/location/domain/repositories/location_repository.dart';
import 'package:ride_sharing_user_app/features/location/domain/repositories/location_repository_interface.dart';
import 'package:ride_sharing_user_app/features/location/domain/services/location_service.dart';
import 'package:ride_sharing_user_app/features/location/domain/services/location_service_interface.dart';
import 'package:ride_sharing_user_app/features/message/domain/repositories/message_repository.dart';
import 'package:ride_sharing_user_app/features/message/domain/repositories/message_repository_interface.dart';
import 'package:ride_sharing_user_app/features/message/domain/services/message_service.dart';
import 'package:ride_sharing_user_app/features/message/domain/services/message_service_interface.dart';
import 'package:ride_sharing_user_app/features/my_level/controller/level_controller.dart';
import 'package:ride_sharing_user_app/features/my_level/domain/repositories/level_repository.dart';
import 'package:ride_sharing_user_app/features/my_level/domain/repositories/level_repository_interface.dart';
import 'package:ride_sharing_user_app/features/my_level/domain/services/level_service.dart';
import 'package:ride_sharing_user_app/features/my_level/domain/services/level_service_interface.dart';
import 'package:ride_sharing_user_app/features/my_offer/controller/offer_controller.dart';
import 'package:ride_sharing_user_app/features/my_offer/domain/repositories/offer_repository.dart';
import 'package:ride_sharing_user_app/features/my_offer/domain/repositories/offer_repository_interface.dart';
import 'package:ride_sharing_user_app/features/my_offer/domain/services/offer_service.dart';
import 'package:ride_sharing_user_app/features/my_offer/domain/services/offer_service_interface.dart';
import 'package:ride_sharing_user_app/features/notification/controllers/notification_controller.dart';
import 'package:ride_sharing_user_app/features/notification/domain/repositories/notification_repository.dart';
import 'package:ride_sharing_user_app/features/notification/domain/repositories/notification_repository_interface.dart';
import 'package:ride_sharing_user_app/features/notification/domain/services/notification_service.dart';
import 'package:ride_sharing_user_app/features/notification/domain/services/notification_service_interface.dart';
import 'package:ride_sharing_user_app/features/onboard/controllers/on_board_page_controller.dart';
import 'package:ride_sharing_user_app/features/parcel/domain/repositories/parcel_repository.dart';
import 'package:ride_sharing_user_app/features/parcel/domain/repositories/parcel_repository_interface.dart';
import 'package:ride_sharing_user_app/features/parcel/domain/services/parcel_service.dart';
import 'package:ride_sharing_user_app/features/parcel/domain/services/parcel_service_interface.dart';
import 'package:ride_sharing_user_app/features/payment/controllers/payment_controller.dart';
import 'package:ride_sharing_user_app/features/payment/domain/repositories/payment_repository.dart';
import 'package:ride_sharing_user_app/features/payment/domain/repositories/payment_repository_interface.dart';
import 'package:ride_sharing_user_app/features/payment/domain/services/payment_service.dart';
import 'package:ride_sharing_user_app/features/payment/domain/services/payment_service_interface.dart';
import 'package:ride_sharing_user_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:ride_sharing_user_app/features/profile/domain/repositories/profile_repository_interface.dart';
import 'package:ride_sharing_user_app/features/profile/domain/services/profile_service.dart';
import 'package:ride_sharing_user_app/features/profile/domain/services/profile_service_interface.dart';
import 'package:ride_sharing_user_app/features/refer_and_earn/controllers/refer_and_earn_controller.dart';
import 'package:ride_sharing_user_app/features/refer_and_earn/domain/repositories/refer_earn_repository.dart';
import 'package:ride_sharing_user_app/features/refer_and_earn/domain/repositories/refer_earn_repository_interface.dart';
import 'package:ride_sharing_user_app/features/refer_and_earn/domain/services/refer_earn_service.dart';
import 'package:ride_sharing_user_app/features/refer_and_earn/domain/services/refer_earn_service_interface.dart';
import 'package:ride_sharing_user_app/features/refund_request/controllers/refund_request_controller.dart';
import 'package:ride_sharing_user_app/features/refund_request/domain/repositories/refund_request_repository.dart';
import 'package:ride_sharing_user_app/features/refund_request/domain/repositories/refund_request_repository_interface.dart';
import 'package:ride_sharing_user_app/features/refund_request/domain/services/refund_request_service.dart';
import 'package:ride_sharing_user_app/features/refund_request/domain/services/refund_request_service_interface.dart';
import 'package:ride_sharing_user_app/features/ride/domain/repositories/ride_repository.dart';
import 'package:ride_sharing_user_app/features/ride/domain/repositories/ride_repository_interface.dart';
import 'package:ride_sharing_user_app/features/ride/domain/services/ride_service.dart';
import 'package:ride_sharing_user_app/features/ride/domain/services/ride_service_interface.dart';
import 'package:ride_sharing_user_app/features/safety_setup/controllers/safety_alert_controller.dart';
import 'package:ride_sharing_user_app/features/safety_setup/domain/repositories/safety_alert_repository.dart';
import 'package:ride_sharing_user_app/features/safety_setup/domain/repositories/safety_alert_repository_interface.dart';
import 'package:ride_sharing_user_app/features/safety_setup/domain/services/safety_alert_service.dart';
import 'package:ride_sharing_user_app/features/safety_setup/domain/services/safety_alert_service_interface.dart';
import 'package:ride_sharing_user_app/features/splash/domain/repositories/config_repository.dart';
import 'package:ride_sharing_user_app/features/splash/domain/repositories/config_repository_interface.dart';
import 'package:ride_sharing_user_app/features/splash/domain/services/config_service.dart';
import 'package:ride_sharing_user_app/features/splash/domain/services/config_service_interface.dart';
import 'package:ride_sharing_user_app/features/support/controllers/help_support_controller.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/features/coupon/controllers/coupon_controller.dart';
import 'package:ride_sharing_user_app/features/coupon/domain/repositories/coupon_repository.dart';
import 'package:ride_sharing_user_app/features/dashboard/controllers/bottom_menu_controller.dart';
import 'package:ride_sharing_user_app/features/address/controllers/address_controller.dart';
import 'package:ride_sharing_user_app/features/home/controllers/banner_controller.dart';
import 'package:ride_sharing_user_app/features/home/controllers/category_controller.dart';
import 'package:ride_sharing_user_app/features/address/domain/repositories/address_repository.dart';
import 'package:ride_sharing_user_app/features/home/domain/repositories/banner_repo.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:ride_sharing_user_app/features/message/controllers/message_controller.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/trip/domain/repositories/trip_repository.dart';
import 'package:ride_sharing_user_app/features/trip/domain/repositories/trip_repository_interface.dart';
import 'package:ride_sharing_user_app/features/trip/domain/services/service.dart';
import 'package:ride_sharing_user_app/features/trip/domain/services/service_interface.dart';
import 'package:ride_sharing_user_app/features/wallet/controllers/wallet_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/repositories/wallet_repository_interface.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/services/wallet_service.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/services/wallet_service_interface.dart';
import 'package:ride_sharing_user_app/localization/language_model.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/theme/theme_controller.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()));

  // Service
  Get.lazyPut(() => AddressService(addressRepositoryInterface: Get.find()));
  Get.lazyPut(() => AuthService(authRepositoryInterface: Get.find()));
  Get.lazyPut(() => CouponService(couponRepositoryInterface: Get.find()));
  Get.lazyPut(() => LocationService(locationRepositoryInterface: Get.find()));
  Get.lazyPut(() => MessageService(messageRepositoryInterface: Get.find()));
  Get.lazyPut(() => NotificationService(notificationRepositoryInterface: Get.find()));
  Get.lazyPut(() => ParcelService(parcelRepositoryInterface: Get.find()));
  Get.lazyPut(() => PaymentService(paymentRepositoryInterface: Get.find()));
  Get.lazyPut(() => ProfileService(profileRepositoryInterface: Get.find()));
  Get.lazyPut(() => RideService(rideRepositoryInterface: Get.find()));
  Get.lazyPut(() => ConfigService(configRepositoryInterface: Get.find()));
  Get.lazyPut(() => TripService(tripRepositoryInterface: Get.find()));
  Get.lazyPut(() => WalletService(walletRepositoryInterface: Get.find()));
  Get.lazyPut(() => OfferService(offerRepositoryInterface: Get.find()));
  Get.lazyPut(() => LevelService(levelRepositoryInterface: Get.find()));
  Get.lazyPut(() => ReferEarnService(referEarnRepositoryInterface: Get.find()));
  Get.lazyPut(() => RefundRequestService(refundRequestRepositoryInterface: Get.find()));
  Get.lazyPut(() => SafetyAlertService(safetyAlertRepositoryInterface: Get.find()));

  // Repository
  Get.lazyPut(() => ConfigRepository(sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => NotificationRepository(apiClient: Get.find()));
  Get.lazyPut(() => TripRepository(apiClient: Get.find()));
  Get.lazyPut(() => WalletRepository(apiClient: Get.find()));
  Get.lazyPut(() => BannerRepo(apiClient: Get.find()));
  Get.lazyPut(() => CategoryRepo(apiClient: Get.find()));
  Get.lazyPut(() => AddressRepository(apiClient: Get.find()));
  Get.lazyPut(() => ParcelRepository(apiClient: Get.find()));
  Get.lazyPut(() => RideRepository(apiClient: Get.find()));
  Get.lazyPut(() => PaymentRepository(apiClient: Get.find(),sharedPreferences: Get.find()));
  Get.lazyPut(() => LocationRepository(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => CouponRepository(apiClient: Get.find()));
  Get.lazyPut(() => AuthRepository(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => ProfileRepository(apiClient: Get.find()));
  Get.lazyPut(() => MessageRepository(apiClient: Get.find()));
  Get.lazyPut(() => OfferRepository(apiClient: Get.find()));
  Get.lazyPut(() => LevelRepository(apiClient: Get.find()));
  Get.lazyPut(() => ReferEarnRepository(apiClient: Get.find()));
  Get.lazyPut(() => RefundRequestRepository(apiClient: Get.find()));
  Get.lazyPut(() => SafetyAlertRepository(apiClient: Get.find()));

  // Controller
  Get.lazyPut(() => ConfigController(configServiceInterface: Get.find()));
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find()));
  Get.lazyPut(() => OnBoardController());
  Get.lazyPut(() => AuthController(authServiceInterface: Get.find()));
  Get.lazyPut(() => NotificationController(notificationServiceInterface: Get.find()));
  Get.lazyPut(() => TripController(tripServiceInterface: Get.find()));
  Get.lazyPut(() => ProfileController(profileServiceInterface: Get.find()));
  Get.lazyPut(() => MessageController(messageServiceInterface: Get.find()));
  Get.lazyPut(() => WalletController(walletService: Get.find()));
  Get.lazyPut(() => BannerController(bannerRepo: Get.find()));
  Get.lazyPut(() => CategoryController(categoryRepo: Get.find()));
  Get.lazyPut(() => AddressController(addressServiceInterface: Get.find()));
  Get.lazyPut(() => MapController());
  Get.lazyPut(() => ParcelController(parcelServiceInterface: Get.find()));
  Get.lazyPut(() => RideController(rideServiceInterface: Get.find()));
  Get.lazyPut(() => PaymentController(paymentServiceInterface: Get.find()));
  Get.lazyPut(() => LocationController(locationServiceInterface: Get.find()));
  Get.lazyPut(() => BottomMenuController());
  Get.lazyPut(() => CouponController(couponServiceInterface: Get.find()));
  Get.lazyPut(() => OfferController(offerServiceInterface: Get.find()));
  Get.lazyPut(() => LevelController(levelServiceInterface: Get.find()));
  Get.lazyPut(() => ReferAndEarnController(referEarnServiceInterface: Get.find()));
  Get.lazyPut(() => HelpSupportController());
  Get.lazyPut(() => RefundRequestController(refundRequestServiceInterface: Get.find()));
  Get.lazyPut(() => SafetyAlertController(safetyAlertServiceInterface: Get.find()));


  AddressRepositoryInterface addressRepositoryInterface = AddressRepository(apiClient: Get.find());
  Get.lazyPut(() => addressRepositoryInterface);
  AddressServiceInterface addressServiceInterface = AddressService(addressRepositoryInterface: Get.find());
  Get.lazyPut(() => addressServiceInterface);

  AuthRepositoryInterface authRepositoryInterface = AuthRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => authRepositoryInterface);
  AuthServiceInterface authServiceInterface = AuthService(authRepositoryInterface: Get.find());
  Get.lazyPut(() => authServiceInterface);

  CouponRepositoryInterface couponRepositoryInterface = CouponRepository(apiClient: Get.find());
  Get.lazyPut(() => couponRepositoryInterface);
  CouponServiceInterface couponServiceInterface = CouponService(couponRepositoryInterface: Get.find());
  Get.lazyPut(() => couponServiceInterface);

  LocationRepositoryInterface locationRepositoryInterface = LocationRepository(apiClient: Get.find(), sharedPreferences:  Get.find());
  Get.lazyPut(() => locationRepositoryInterface);
  LocationServiceInterface locationServiceInterface = LocationService(locationRepositoryInterface: Get.find());
  Get.lazyPut(() => locationServiceInterface);

  MessageRepositoryInterface messageRepositoryInterface = MessageRepository(apiClient: Get.find());
  Get.lazyPut(() => messageRepositoryInterface);
  MessageServiceInterface messageServiceInterface = MessageService(messageRepositoryInterface: Get.find());
  Get.lazyPut(() => messageServiceInterface);

  NotificationRepositoryInterface notificationRepositoryInterface = NotificationRepository(apiClient: Get.find());
  Get.lazyPut(() => notificationRepositoryInterface);
  NotificationServiceInterface notificationServiceInterface = NotificationService(notificationRepositoryInterface: Get.find());
  Get.lazyPut(() => notificationServiceInterface);

  ParcelRepositoryInterface parcelRepositoryInterface = ParcelRepository(apiClient: Get.find());
  Get.lazyPut(() => parcelRepositoryInterface);
  ParcelServiceInterface parcelServiceInterface = ParcelService(parcelRepositoryInterface: Get.find());
  Get.lazyPut(() => parcelServiceInterface);

  PaymentRepositoryInterface paymentRepositoryInterface = PaymentRepository(apiClient: Get.find(),sharedPreferences: Get.find());
  Get.lazyPut(() => paymentRepositoryInterface);
  PaymentServiceInterface paymentServiceInterface = PaymentService(paymentRepositoryInterface: Get.find());
  Get.lazyPut(() => paymentServiceInterface);

  ProfileRepositoryInterface profileRepositoryInterface = ProfileRepository(apiClient: Get.find());
  Get.lazyPut(() => profileRepositoryInterface);
  ProfileServiceInterface profileServiceInterface = ProfileService(profileRepositoryInterface: Get.find());
  Get.lazyPut(() => profileServiceInterface);

  RideRepositoryInterface rideRepositoryInterface = RideRepository(apiClient: Get.find());
  Get.lazyPut(() => rideRepositoryInterface);
  RideServiceInterface rideServiceInterface = RideService(rideRepositoryInterface: Get.find());
  Get.lazyPut(() => rideServiceInterface);

  ConfigRepositoryInterface configRepositoryInterface = ConfigRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => configRepositoryInterface);
  ConfigServiceInterface configServiceInterface = ConfigService(configRepositoryInterface: Get.find());
  Get.lazyPut(() => configServiceInterface);

  TripRepositoryInterface tripRepositoryInterface = TripRepository(apiClient: Get.find());
  Get.lazyPut(() => tripRepositoryInterface);
  TripServiceInterface tripServiceInterface = TripService(tripRepositoryInterface: Get.find());
  Get.lazyPut(() => tripServiceInterface);

  WalletRepositoryInterface walletRepositoryInterface = WalletRepository(apiClient: Get.find());
  Get.lazyPut(() => walletRepositoryInterface);
  WalletServiceInterface walletServiceInterface = WalletService(walletRepositoryInterface: Get.find());
  Get.lazyPut(() => walletServiceInterface);

  OfferRepositoryInterface offerRepositoryInterface = OfferRepository(apiClient: Get.find());
  Get.lazyPut(() => offerRepositoryInterface);
  OfferServiceInterface offerServiceInterface = OfferService(offerRepositoryInterface: Get.find());
  Get.lazyPut(() => offerServiceInterface);

  LevelRepositoryInterface levelRepositoryInterface = LevelRepository(apiClient: Get.find());
  Get.lazyPut(() => levelRepositoryInterface);
  LevelServiceInterface levelServiceInterface = LevelService(levelRepositoryInterface: Get.find());
  Get.lazyPut(() => levelServiceInterface);

  ReferEarnRepositoryInterface referEarnRepositoryInterface = ReferEarnRepository(apiClient: Get.find());
  Get.lazyPut(() => referEarnRepositoryInterface);
  ReferEarnServiceInterface referEarnServiceInterface = ReferEarnService(referEarnRepositoryInterface: Get.find());
  Get.lazyPut(() => referEarnServiceInterface);

  RefundRequestRepositoryInterface refundRequestRepositoryInterface = RefundRequestRepository(apiClient: Get.find());
  Get.lazyPut(() => refundRequestRepositoryInterface);
  RefundRequestServiceInterface refundRequestServiceInterface = RefundRequestService(refundRequestRepositoryInterface: Get.find());
  Get.lazyPut(() => refundRequestServiceInterface);

  SafetyAlertRepositoryInterface safetyAlertRepositoryInterface = SafetyAlertRepository(apiClient: Get.find());
  Get.lazyPut(() => safetyAlertRepositoryInterface);
  SafetyAlertServiceInterface safetyAlertServiceInterface = SafetyAlertService(safetyAlertRepositoryInterface: Get.find());
  Get.lazyPut(() => safetyAlertServiceInterface);

  // Retrieving localized data
  Map<String, Map<String, String>> languages = {};
  for(LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues =  await rootBundle.loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    Map<String, String> languageJson = {};
    mappedJson.forEach((key, value) {
      languageJson[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] = languageJson;
  }
  return languages;
}
