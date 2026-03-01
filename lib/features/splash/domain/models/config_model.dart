class ConfigModel {
  String? businessName;
  String? logo;
  bool? bidOnFare;
  String? countryCode;
  String? businessAddress;
  String? businessContactPhone;
  String? businessContactEmail;
  String? businessSupportPhone;
  String? businessSupportEmail;
  String? baseUrl;
  ImageBaseUrl? imageBaseUrl;
  String? currencyDecimalPoint;
  String? currencyCode;
  String? currencySymbolPosition;
  AboutUs? aboutUs;
  AboutUs? privacyPolicy;
  AboutUs? termsAndConditions;
  AboutUs? legal;
  bool? smsVerification;
  bool? emailVerification;
  String? mapApiKey;
  int? paginationLimit;
  String? facebookLogin;
  String? googleLogin;
  List<String>? timeZones;
  bool? verification;
  List<PaymentGateways>? paymentGateways;
  bool? conversionStatus;
  int? conversionRate;
  bool? addIntermediatePoint;
  int? otpResendTime;
  String? currencySymbol;
  int? tripActiveTime;
  bool? reviewStatus;
  MaintenanceMode? maintenanceMode;
  String? webSocketUrl;
  String? webSocketPort;
  String? webSocketKey;
  double? searchRadius;
  double? completionRadius;
  bool? isDemo;
  bool? levelStatus;
  int? popularTips;
  bool? externalSystem;
  String? martBusinessName;
  String? martPlayStoreUrl;
  String? martAppStoreUrl;
  bool? referralEarningStatus;
  double? androidAppMinimumVersion;
  double? iosAppMinimumVersion;
  String? androidAppUrl;
  String? iosAppUrl;
  bool? parcelRefundStatus;
  int? parcelRefundValidity;
  String? parcelRefundValidityType;
  bool? isFirebaseOtpVerification;
  List<ZoneExtraFare>? zoneExtraFare;
  AboutUs? refundPolicy;
  bool? isSmsGateway;
  String? websocketScheme;
  bool? maximumParcelWeightStatus;
  double? maximumParcelWeightCapacity;
  String? parcelWeightUnit;
  bool? safetyFeatureStatus;
  int? safetyFeatureMinimumTripDelayTime;
  String? safetyFeatureMinimumTripDelayTimeType;
  bool? afterTripCompleteSafetyFeatureActiveStatus;
  int? afterTripCompleteSafetyFeatureSetTime;
  String? safetyFeatureEmergencyGovtNumber;
  bool? otpConfirmationForTrip;
  bool? scheduleTripStatus;
  int? minimumScheduleBookTime;
  String? minimumScheduleBookTimeType;
  int? advanceScheduleBookTime;
  String? advanceScheduleBookTimeType;
  bool? walletAddFundStatus;
  double? walletMinimumDepositLimit;
  int? maxImageUploadSize;
  int? maxFileUploadSize;
  bool? isOtpLoginEnable;


  ConfigModel(
      {this.businessName,
        this.logo,
        this.bidOnFare,
        this.countryCode,
        this.businessAddress,
        this.businessContactPhone,
        this.businessContactEmail,
        this.businessSupportPhone,
        this.businessSupportEmail,
        this.baseUrl,
        this.imageBaseUrl,
        this.currencyDecimalPoint,
        this.currencyCode,
        this.currencySymbolPosition,
        this.aboutUs,
        this.privacyPolicy,
        this.termsAndConditions,
        this.legal,
        this.smsVerification,
        this.emailVerification,
        this.mapApiKey,
        this.paginationLimit,
        this.facebookLogin,
        this.googleLogin,
        this.timeZones,
        this.verification,
        this.paymentGateways,
        this.conversionStatus,
        this.conversionRate,
        this.addIntermediatePoint,
        this.otpResendTime,
        this.currencySymbol,
        this.tripActiveTime,
        this.reviewStatus,
        this.maintenanceMode,
        this.webSocketUrl,
        this.webSocketPort,
        this.webSocketKey,
        this.searchRadius,
        this.completionRadius,
        this.isDemo,
        this.levelStatus,
        this.popularTips,
        this.externalSystem,
        this.martBusinessName,
        this.martPlayStoreUrl,
        this.martAppStoreUrl,
        this.referralEarningStatus,
        this.androidAppMinimumVersion,
        this.androidAppUrl,
        this.iosAppMinimumVersion,
        this.iosAppUrl,
        this.parcelRefundStatus,
        this.parcelRefundValidity,
        this.parcelRefundValidityType,
        this.isFirebaseOtpVerification,
        this.zoneExtraFare,
        this.refundPolicy,
        this.isSmsGateway,
        this.websocketScheme,
        this.maximumParcelWeightStatus,
        this.maximumParcelWeightCapacity,
        this.parcelWeightUnit,
        this.afterTripCompleteSafetyFeatureActiveStatus,
        this.afterTripCompleteSafetyFeatureSetTime,
        this.safetyFeatureEmergencyGovtNumber,
        this.safetyFeatureMinimumTripDelayTime,
        this.safetyFeatureMinimumTripDelayTimeType,
        this.safetyFeatureStatus,
        this.otpConfirmationForTrip,
        this.scheduleTripStatus,
        this.advanceScheduleBookTime,
        this.advanceScheduleBookTimeType,
        this.minimumScheduleBookTime,
        this.minimumScheduleBookTimeType,
        this.walletAddFundStatus,
        this.walletMinimumDepositLimit,
        this.maxImageUploadSize,
        this.maxFileUploadSize,
        this.isOtpLoginEnable
      });

  ConfigModel.fromJson(Map<String, dynamic> json) {
    businessName = json['business_name'];
    logo = json['logo'];
    bidOnFare = json['bid_on_fare'];
    if(json['country_code'] != null && json['country_code'] != ""){
      countryCode = json['country_code']??'BD';
    }else{
      countryCode = 'BD';
    }

    businessAddress = json['business_address'];
    businessContactPhone = json['business_contact_phone'];
    businessContactEmail = json['business_contact_email'];
    businessSupportPhone = json['business_support_phone'];
    businessSupportEmail = json['business_support_email'];
    baseUrl = json['base_url'];
    webSocketUrl = json['websocket_url'];
    webSocketPort = json['websocket_port'];
    webSocketKey = json['websocket_key'];
    imageBaseUrl = json['image_base_url'] != null
        ? ImageBaseUrl.fromJson(json['image_base_url'])
        : null;
    currencyDecimalPoint = json['currency_decimal_point'];
    currencyCode = json['currency_code'];
    currencySymbolPosition = json['currency_symbol_position'];
    aboutUs = json['about_us'] != null
        ? AboutUs.fromJson(json['about_us'])
        : null;
    privacyPolicy = json['privacy_policy'] != null
        ? AboutUs.fromJson(json['privacy_policy'])
        : null;
    termsAndConditions = json['terms_and_conditions'] != null
        ? AboutUs.fromJson(json['terms_and_conditions'])
        : null;
    legal = json['legal'] != null
        ? AboutUs.fromJson(json['legal'])
        : null;
    smsVerification = json['sms_verification'];
    emailVerification = json['email_verification'];
    mapApiKey = json['map_api_key'];
    paginationLimit = json['pagination_limit'];
    facebookLogin = json['facebook_login'].toString();
    googleLogin = json['google_login'].toString();
    verification = '${json['verification']}'.contains('true');
    conversionStatus = json['conversion_status'];
    conversionRate = json['conversion_rate'];
    addIntermediatePoint = json['add_intermediate_points'];
    otpResendTime = int.parse(json['otp_resend_time'].toString());
    currencySymbol = json['currency_symbol'];
    tripActiveTime = json['trip_request_active_time'];
    reviewStatus = json['review_status'];
    maintenanceMode = json['maintenance_mode'] != null
        ? MaintenanceMode.fromJson(json['maintenance_mode'])
        : null;
    isDemo = json['is_demo'];
    levelStatus = json['level_status'];
    popularTips = json['popular_tips'];
    if (json['payment_gateways'] != null) {
      paymentGateways = <PaymentGateways>[];
      json['payment_gateways'].forEach((v) {
        paymentGateways!.add(PaymentGateways.fromJson(v));
      });
    }
    if(json['driver_completion_radius'] != null){
      try{
        completionRadius = json['driver_completion_radius'].toDouble();
      }catch(e){
        completionRadius = double.parse(json['driver_completion_radius'].toString());
      }
    }
    if(json['search_radius'] != null){
      try{
        searchRadius = json['search_radius'].toDouble();
      }catch(e){
        searchRadius = double.parse(json['search_radius'].toString());
      }
    }
    externalSystem = json['external_system'];
    martBusinessName = json['mart_business_name'];
    martPlayStoreUrl = json['mart_app_url_android'];
    martAppStoreUrl = json['mart_app_url_ios'];
    referralEarningStatus = json['referral_earning_status'];
    androidAppMinimumVersion = json['app_minimum_version_for_android'].toDouble();
    androidAppUrl = json['app_url_for_android'];
    iosAppMinimumVersion = json['app_minimum_version_for_ios'].toDouble();
    iosAppUrl = json['app_url_for_ios'];
    parcelRefundStatus = json['parcel_refund_status'];
    parcelRefundValidity = json['parcel_refund_validity'];
    parcelRefundValidityType = json['parcel_refund_validity_type'];
    isFirebaseOtpVerification = json['firebase_otp_verification'];
    isSmsGateway = json['sms_gateway'];
    websocketScheme = json['websocket_scheme'];
    parcelWeightUnit = json['parcel_weight_unit'];
    zoneExtraFare = List<ZoneExtraFare>.from(json["zone_extra_fare"].map((x) => ZoneExtraFare.fromJson(x)));
    refundPolicy = json['refund_policy'] != null ? AboutUs.fromJson(json['refund_policy']) : null;
    maximumParcelWeightStatus = json['maximum_parcel_weight_status'];
    safetyFeatureStatus = json['safety_feature_status'];
    safetyFeatureMinimumTripDelayTime = json['safety_feature_minimum_trip_delay_time'];
    safetyFeatureMinimumTripDelayTimeType = json['safety_feature_minimum_trip_delay_time_type'];
    afterTripCompleteSafetyFeatureActiveStatus = json['after_trip_completed_safety_feature_active_status'];
    afterTripCompleteSafetyFeatureSetTime = json['after_trip_completed_safety_feature_set_time'];
    safetyFeatureEmergencyGovtNumber = json['safety_feature_emergency_govt_number'];
    maximumParcelWeightCapacity = json['maximum_parcel_weight_capacity'] != null ? double.parse(json['maximum_parcel_weight_capacity'].toString()) : null;
    otpConfirmationForTrip = json['otp_confirmation_for_trip'];
    scheduleTripStatus = json['schedule_trip_status'];
    advanceScheduleBookTime = json['advance_schedule_book_time'];
    advanceScheduleBookTimeType = json['advance_schedule_book_time_type'];
    minimumScheduleBookTime = json['minimum_schedule_book_time'];
    minimumScheduleBookTimeType = json['minimum_schedule_book_time_type'];
    walletAddFundStatus = json['wallet_add_fund_status'];
    isOtpLoginEnable = json['is_otp_enabled'];
    walletMinimumDepositLimit = double.tryParse('${json['wallet_minimum_deposit_limit']}');
    maxImageUploadSize = int.tryParse('${json['upload_max_image_size']}');
    maxFileUploadSize = int.tryParse('${json['upload_max_file_size']}');
  }

}


class ImageBaseUrl {
  String? profileImageDriver;
  String? banner;
  String? vehicleCategory;
  String? vehicleModel;
  String? vehicleBrand;
  String? profileImage;
  String? identityImage;
  String? documents;
  String? level;
  String? pages;
  String? conversation;
  String? parcel;

  ImageBaseUrl(
      {this.profileImageDriver,
        this.banner,
        this.vehicleCategory,
        this.vehicleModel,
        this.vehicleBrand,
        this.profileImage,
        this.identityImage,
        this.documents,
        this.level,
        this.pages,
        this.conversation,
        this.parcel
      });

  ImageBaseUrl.fromJson(Map<String, dynamic> json) {
    profileImageDriver = json['profile_image_driver'];
    banner = json['banner'];
    vehicleCategory = json['vehicle_category'];
    vehicleModel = json['vehicle_model'];
    vehicleBrand = json['vehicle_brand'];
    profileImage = json['profile_image'];
    identityImage = json['identity_image'];
    documents = json['documents'];
    level = json['level'];
    pages = json['pages'];
    conversation = json['conversation'];
    parcel =  json['parcel'];
  }


}
class AboutUs {
  String? image;
  String? name;
  String? shortDescription;
  String? longDescription;

  AboutUs({this.image, this.name, this.shortDescription, this.longDescription});

  AboutUs.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    name = json['name'];
    shortDescription = json['short_description'];
    longDescription = json['long_description'];
  }

}
class PaymentGateways {
  String? gateway;
  String? gatewayTitle;
  String? gatewayImage;

  PaymentGateways({this.gateway, this.gatewayTitle, this.gatewayImage});

  PaymentGateways.fromJson(Map<String, dynamic> json) {
    gateway = json['gateway'];
    gatewayTitle = json['gateway_title'];
    gatewayImage = json['gateway_image'];
  }

}

class MaintenanceMode {
  int? maintenanceStatus;
  SelectedMaintenanceSystem? selectedMaintenanceSystem;
  MaintenanceMessages? maintenanceMessages;
  MaintenanceTypeAndDuration? maintenanceTypeAndDuration;

  MaintenanceMode({
    this.maintenanceStatus,
    this.selectedMaintenanceSystem,
    this.maintenanceMessages,
    this.maintenanceTypeAndDuration
  });

  MaintenanceMode.fromJson(Map<String, dynamic> json) {
    maintenanceStatus = json['maintenance_status'];
    selectedMaintenanceSystem = json['selected_maintenance_system'] != null
        ? SelectedMaintenanceSystem.fromJson(
        json['selected_maintenance_system'])
        : null;
    maintenanceMessages = json['maintenance_messages'] != null
        ? MaintenanceMessages.fromJson(json['maintenance_messages'])
        : null;

    maintenanceTypeAndDuration = json['maintenance_type_and_duration'] != null
        ? MaintenanceTypeAndDuration.fromJson(
        json['maintenance_type_and_duration'])
        : null;
  }

}

class SelectedMaintenanceSystem {
  int? userApp;
  int? driverApp;

  SelectedMaintenanceSystem(
      { this.userApp, this.driverApp});

  SelectedMaintenanceSystem.fromJson(Map<String, dynamic> json) {
    userApp = json['user_app'];
    driverApp = json['driver_app'];
  }

}

class MaintenanceMessages {
  int? businessNumber;
  int? businessEmail;
  String? maintenanceMessage;
  String? messageBody;

  MaintenanceMessages(
      {this.businessNumber,
        this.businessEmail,
        this.maintenanceMessage,
        this.messageBody});

  MaintenanceMessages.fromJson(Map<String, dynamic> json) {
    businessNumber = json['business_number'];
    businessEmail = json['business_email'];
    maintenanceMessage = json['maintenance_message'];
    messageBody = json['message_body'];
  }

}

class MaintenanceTypeAndDuration {
  String? maintenanceDuration;
  String? startDate;
  String? endDate;

  MaintenanceTypeAndDuration(
      {String? maintenanceDuration, String? startDate, String? endDate}) {
    if (maintenanceDuration != null) {
      maintenanceDuration = maintenanceDuration;
    }
    if (startDate != null) {
      startDate = startDate;
    }
    if (endDate != null) {
      endDate = endDate;
    }
  }

  MaintenanceTypeAndDuration.fromJson(Map<String, dynamic> json) {
    maintenanceDuration = json['maintenance_duration'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

}


class ZoneExtraFare {
  bool status;
  String zoneId;
  String reason;

  ZoneExtraFare({
    required this.status,
    required this.zoneId,
    required this.reason,
  });

  factory ZoneExtraFare.fromJson(Map<String, dynamic> json) => ZoneExtraFare(
    status: json["status"],
    zoneId: json["zone_id"],
    reason: json["reason"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "zone_id": zoneId,
    "reason": reason,
  };
}
