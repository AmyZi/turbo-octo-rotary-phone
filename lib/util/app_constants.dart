import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/onboard/domain/models/on_boarding_model.dart';
import 'package:ride_sharing_user_app/localization/language_model.dart';
import 'package:ride_sharing_user_app/util/images.dart';

class AppConstants {
  static const String appName = 'Way2Go';
  static const String baseUrl = 'https://way2go-lb.com';
  static const double appVersion = 3.0; /// Flutter SDK 3.38.7
  static const String fontFamily = 'SFProText';
  static const double coverageRadiusInMeter = 50;
  static const String configUri = '/api/customer/configuration';
  static const String registration = '/api/customer/auth/registration';
  static const String loginUri = '/api/customer/auth/login';
  static const String logOutUri = '/api/user/logout';
  static const String deleteAccount = '/api/user/delete';
  static const String sendOTP = '/api/customer/auth/send-otp';
  static const String otpVerification = '/api/customer/auth/otp-verification';
  static const String otpLogin = '/api/customer/auth/otp-login';
  static const String resetPassword = '/api/customer/auth/reset-password';
  static const String changePassword = '/api/user/change-password';
  static const String forgetPassword = '/api/customer/auth/forget-password';
  static const String socialLogin = '/api/customer/auth/social-login';
  static const String profileInfo = '/api/customer/info';
  static const String updateProfileInfo = '/api/customer/update/profile';
  static const String bannerUei = '/api/customer/banner/list?limit=100&offset=1';
  static const String bannerCountUpdate = '/api/customer/banner/update-redirection-count';
  static const String vehicleMainCategory = '/api/customer/vehicle/category?limit=100&offset=1';
  static const String getZone = '/api/customer/config/get-zone-id';
  static const String geoCodeURI = '/api/customer/config/geocode-api';
  static const String searchLocationUri = '/api/customer/config/place-api-autocomplete';
  static const String placeApiDetails = '/api/customer/config/place-api-details';
  /// Predefined Lebanon areas for client-side search (no Google Places).
  static const String addressesCatalogUri = '/api/addresses';
  static const String estimatedFare = '/api/customer/ride/get-estimated-fare';
  static const String rideRequest = '/api/customer/ride/create';
  static const String addNewAddress = '/api/customer/address/add';
  static const String getAddressList = '/api/customer/address/all-address?limit=10&offset=';
  static const String getRecentAddressList = '/api/customer/recent-address';
  static const String updateAddress = '/api/customer/address/update';
  static const String deleteAddress = '/api/customer/address/delete';
  static const String fcmTokenUpdate = '/api/customer/update/fcm-token';
  static const String updateLasLocation = '/api/customer/ride/track-location';
  static const String tripDetails = '/api/customer/ride/details/';
  static const String tripAcceptOrReject = '/api/customer/ride/trip-action';
  static const String couponList = '/api/customer/coupon/list?limit=10&offset=';
  static const String remainDistance = '/api/customer/config/get-routes';
  static const String biddingList = '/api/customer/ride/bidding-list/';
  static const String ignoreBidding = '/api/customer/ride/ignore-bidding';
  static const String nearestDriverList = '/api/customer/drivers-near-me';
  static const String currentRideStatus = '/api/customer/ride/ride-resume-status';
  static const String updateTripStatus = '/api/customer/ride/update-status/';
  static const String finalFare = '/api/customer/ride/final-fare';
  static const String submitReview = '/api/customer/review/store';
  static const String tripList = '/api/customer/ride/list';
  static const String paymentUri = '/api/customer/ride/payment';
  static const String digitalPayment = '/api/customer/ride/digital-payment';
  static const String createChannel = '/api/customer/chat/create-channel';
  static const String channelList = '/api/customer/chat/channel-list';
  static const String conversationList = '/api/customer/chat/conversation';
  static const String sendMessage = '/api/customer/chat/send-message';
  static const String arrivalPickupPoint = '/api/customer/ride/arrival-time';
  static const String parcelCategoryUri = '/api/customer/parcel/category?limit=100&offset=1';
  static const String suggestedVehicleCategory = '/api/customer/parcel/suggested-vehicle-category?parcel_weight=';
  static const String notificationList = '/api/customer/notification-list?limit=10&offset=';
  static const String transactionListUri = '/api/customer/transaction/list?limit=10&offset=';
  static const String loyaltyPointListUri = '/api/customer/loyalty-points/list?limit=10&offset=';
  static const String pointConvert = '/api/customer/loyalty-points/convert';
  static const String alreadySubmittedReview = '/api/customer/review/check-submission';
  static const String parcelOngoingList = '/api/customer/ride/ongoing-parcel-list?limit=100&offset=1';
  static const String parcelUnpaidList = '/api/customer/ride/unpaid-parcel-list?limit=100&offset=1';
  static const String getDriverLocation = '/api/user/get-live-location?trip_request_id=';
  static const String findChannelRideStatus = '/api/customer/chat/find-channel';
  static const String getPaymentMethods = '/api/customer/config/get-payment-methods';
  static const String rideCancellationReasonList = '/api/customer/config/cancellation-reason-list';
  static const String customerAppliedCoupon = '/api/customer/applied-coupon';
  static const String bestOfferList = '/api/customer/discount/list?limit=10&offset=';
  static const String changeLanguage = '/api/customer/change-language';
  static const String getProfileLevel = '/api/customer/level';
  static const String externalLoginUri = '/api/customer/auth/external-login';
  static const String transferMoneyFromDrivemondToMart = '/api/customer/wallet/transfer-drivemond-to-mart';
  static const String referralDetails = '/api/customer/referral-details';
  static const String referralEarningList = '/api/customer/transaction/referral-earning-list?limit=10&offset=';
  static const String parcelCancellationReasonList = '/api/customer/config/parcel-cancellation-reason-list';
  static const String parcelReceived = '/api/customer/ride/received-returning-parcel/';
  static const String getParcelRefundReasonList = '/api/customer/config/parcel-refund-reason-list';
  static const String parcelRefundCreate = '/api/customer/parcel/refund/create';
  static const String otpFirebaseVerification = '/api/customer/auth/firebase-otp-verification';
  static const String checkRegisteredUserUri = '/api/customer/auth/check';
  static const String getSafetyAlertReasonList = '/api/customer/config/safety-alert-reason-list';
  static const String getOtherEmergencyNumberList = '/api/customer/config/other-emergency-contact-list';
  static const String storeSafetyAlert = '/api/customer/safety-alert/store';
  static const String resendSafetyAlert = '/api/customer/safety-alert/resend/';
  static const String markAsSolvedSafetyAlert = '/api/customer/safety-alert/mark-as-solved/';
  static const String customerAlertDetails = '/api/customer/safety-alert/show/';
  static const String getPrecautionList = '/api/customer/config/safety-precaution-list';
  static const String storeLastLocationAPI = '/api/user/store-live-location';
  static const String undoSafetyAlert = '/api/customer/safety-alert/undo/';
  static const String readNotification = '/api/user/read-notification';
  static const String updateScheduleTrip = '/api/customer/ride/edit-scheduled-trip/';
  static const String getRunningRideList = '/api/customer/ride/pending-ride-list';
  static const String getAddFundPromotionalList = '/api/customer/wallet/bonus-list';
  static const String digitalAddFund = '/api/customer/wallet/add-fund-digitally';



  /// Shared Key
  static const String notification = 'notification';
  static const String theme = 'theme';
  static const String token = 'token';
  static const String paymentMethod = 'payment_method';
  static const String paymentType = 'paymentType';
  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';
  static const String haveOngoingRides = 'have_ongoing_rides';
  static const String userPassword = 'user_password';
  static const String userAddress = 'user_address';
  static const String userNumber = 'user_number';
  static const String loginCountryCode = 'login_country_code';
  static const String searchAddress = 'search_address';
  static const String localization = 'X-Localization';
  static const String topic = 'notify';
  static const String intro = 'intro';
  static const String zoneId = 'zone_id';
  static const String externalUserPhone = 'external_user_phone';
  static const String externalUserPassword = 'external_user_password';
  static const String externalUserCountryCode = 'external_user_countryCode';

  /// Status
  static const String pending = 'pending';
  static const String accepted = 'accepted';
  static const String outForPickup = 'out_for_pickup';
  static const String ongoing = 'ongoing';
  static const String completed = 'completed';
  static const String cancelled = 'cancelled';
  static const String returning = 'returning';
  static const String returned = 'returned';
  static const String parcel = 'parcel';
  static const String unPaid = 'unpaid';
  static const String paid = 'paid';
  static const String findingRider = 'findingRider';
  static const String initial = 'initial';
  static const String riseFare = 'riseFare';
  static const String pickUpRide = 'pickUpRide';
  static const String afterAcceptRider = 'afterAcceptRider';
  static const String otpSend = 'otpSent';
  static const String ongoingRide = 'ongoingRide';
  static const String completeRide = 'completeRide';
  static const String sender = 'sender';
  static const String scheduleRequest = 'scheduled_request';
  static const double otpShownArea = 500;

  ///map zoom
  static const double mapZoom = 20;


  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: Images.unitedKingdom, languageName: 'English', countryCode: 'US', languageCode: 'en',),
    LanguageModel(imageUrl: Images.saudi, languageName: 'عربي', countryCode: 'SA', languageCode: 'ar'),
  ];


  static const int imageQuality = 80;

  /// Allowed image file extensions for upload
  static const List<String> allowedImageExtensions = [
    'png',
    'jpg',
    'jpeg',
    'gif',
    'webp',
  ];

  static const List<String> allowedImageExtensionsForFile = [
    'csv', 'doc','jpeg','jpg','pdf','png','webp','xlsx', 'docx', 'zip'
  ];

  static List<OnBoardingModel> onBoardPagerData = [
    OnBoardingModel(title1: 'onboard_one_part_one'.tr, title2: 'onboard_one_part_two'.tr, title3: '', title4: '', image: 'assets/svg/onboarding_one.svg'),
    OnBoardingModel(title1: '', title2: 'onboard_two_part_one'.tr, title3: 'onboard_two_part_two'.tr, title4: 'onboard_two_part_three'.tr, image: 'assets/svg/onboarding_two.svg'),
    OnBoardingModel(title1: '', title2: 'onboard_three_part_one'.tr, title3: 'onboard_three_part_two'.tr, title4: 'onboard_three_part_three'.tr, image: 'assets/svg/onboarding_three.svg'),
    OnBoardingModel(title1: 'onboard_four_part_one'.tr, title2: 'onboard_four_part_two'.tr, title3: 'onboard_four_part_three'.tr, title4: 'onboard_four_part_four'.tr,  image: 'assets/svg/onboarding_four.svg'),
  ];
}
