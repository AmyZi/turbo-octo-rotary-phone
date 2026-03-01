import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/auth/domain/models/sign_up_body.dart';
import 'package:ride_sharing_user_app/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/features/address/domain/models/address_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository implements AuthRepositoryInterface{
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future<Response?> login({required String phone, required String password}) async {
    return await apiClient.postData(AppConstants.loginUri, {"phone_or_email": phone, "password": password});
  }

  @override
  Future<Response?> externalLogin({required String phone, required String password}) async {
    return await apiClient.postData(AppConstants.externalLoginUri, {"phone_or_email": phone, "token": password});
  }

  @override
  Future<Response?> logOut() async {
    return await apiClient.postData(AppConstants.logOutUri, {});
  }



  @override
  Future<Response?> registration({required SignUpBody signUpBody}) async {
    return await apiClient.postData(AppConstants.registration, signUpBody.toJson());
  }



  @override
  Future<Response?> sendOtp({required String phone}) async {
    return await apiClient.postData(AppConstants.sendOTP,
        {"phone_or_email": phone});
  }

  @override
  Future<Response?> isUserRegistered({required String phone}) async {
    return await apiClient.postData(AppConstants.checkRegisteredUserUri,
        {"phone_or_email": phone});
  }

  @override
  Future<Response?> verifyOtp({required String phone, required String otp}) async {
    return await apiClient.postData(AppConstants.otpVerification,
        {"phone_or_email": phone,
          "otp": otp
        });
  }


  @override
  Future<Response?> verifyFirebaseOtp({required String phone, required String otp, required String session}) async {
    return await apiClient.postData(AppConstants.otpFirebaseVerification,
        {"phone_or_email": phone,
          "code": otp,
          "session_info": session
        });
  }


  @override
  Future<Response?> otpLogin({required String phone, required String otp}) async {
    return await apiClient.postData(AppConstants.otpLogin,
        {"phone_or_email": phone,
          "otp": otp
        });
  }


  @override
  Future<Response?> resetPassword(String phoneOrEmail, String password) async {
    return await apiClient.postData(AppConstants.resetPassword,
      { "phone_or_email": phoneOrEmail,
        "password": password,},
    );
  }

  @override
  Future<Response?> changePassword(String oldPassword, String password) async {
    return await apiClient.postData(AppConstants.changePassword,
      { "password": oldPassword,
        "new_password": password,
      },
    );
  }

  @override
  Future<Response?> updateToken() async {
    String? deviceToken;
    if (GetPlatform.isIOS && !GetPlatform.isWeb) {
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
        alert: true, announcement: false, badge: true, carPlay: false,
        criticalAlert: false, provisional: false, sound: true,
      );
      if(settings.authorizationStatus == AuthorizationStatus.authorized) {
        deviceToken = await _saveDeviceToken();
      }
    }else {
      deviceToken = await _saveDeviceToken();
    }

    if(!GetPlatform.isWeb){

        FirebaseMessaging.instance.subscribeToTopic(AppConstants.topic);

    }
    return await apiClient.postData(AppConstants.fcmTokenUpdate, {"_method": "put", "fcm_token": deviceToken});
  }

  Future<String?> _saveDeviceToken() async {
    String? deviceToken = '@';
    try {
      deviceToken = await FirebaseMessaging.instance.getToken();
    }catch(e) {
      log('--------Device Token---------- $deviceToken');
    }
    if (deviceToken != null) {
      log('--------Device Token---------- $deviceToken');
    }
    return deviceToken;
  }



  @override
  Future<Response?> forgetPassword(String? phone) async {
    return await apiClient.postData(AppConstants.configUri, {"phone_or_email": phone});
  }

  @override
  Future<Response?> verifyToken(String phone, String otp) async {
    return await apiClient.postData(AppConstants.configUri, {"phone_or_email": phone.substring(1,phone.length-1), "otp": otp});
  }


  @override
  Future<Response?> checkEmail(String email) async {
    return await apiClient.postData(AppConstants.configUri, {"email": email});
  }

  @override
  Future<Response?> verifyEmail(String email, String token) async {
    return await apiClient.postData(AppConstants.configUri, {"email": email, "token": token});
  }



  @override
  Future<Response?> verifyPhone(String phone, String otp) async {
    return await apiClient.postData(AppConstants.configUri, {"phone": phone, "otp": otp});
  }

  @override
  Future<bool?> saveUserToken(String token) async {
    Address? address;
    try {
      address = Address.fromJson(jsonDecode(sharedPreferences.getString(AppConstants.userAddress)!));
      // ignore: empty_catches
    }catch(e) {
    }
    apiClient.updateHeader(token, address);
    return await sharedPreferences.setString(AppConstants.token, token);

  }


  @override
  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  @override
  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.token);
  }

  @override
  bool clearSharedData() {
    sharedPreferences.remove(AppConstants.token);
    sharedPreferences.remove(AppConstants.userAddress);
    return true;
  }

  @override
  Future<void> saveUserNumberAndPassword(String code, String number, String password, bool externalUser) async {
    if(externalUser){
      try {
        await sharedPreferences.setString(AppConstants.externalUserPassword, password);
        await sharedPreferences.setString(AppConstants.externalUserPhone, number);
        await sharedPreferences.setString(AppConstants.externalUserCountryCode, code);
      } catch (e) {
        rethrow;
      }
    }else{
      try {
        await sharedPreferences.setString(AppConstants.userPassword, password);
        await sharedPreferences.setString(AppConstants.userNumber, number);
        await sharedPreferences.setString(AppConstants.loginCountryCode, code);

      } catch (e) {
        rethrow;
      }
    }
  }

  @override
  String getUserNumber(bool externalUser) {
    if(externalUser){
      return sharedPreferences.getString(AppConstants.externalUserPhone) ?? "";
    }else{
      return sharedPreferences.getString(AppConstants.userNumber) ?? "";
    }
  }

  @override
  String getLoginCountryCode(bool externalUser) {
    if(externalUser){
      return sharedPreferences.getString(AppConstants.externalUserCountryCode) ?? "";
    }else{
      return sharedPreferences.getString(AppConstants.loginCountryCode) ?? "";
    }
  }



  @override
  String getUserPassword(bool externalUser) {
    if(externalUser){
      return sharedPreferences.getString(AppConstants.externalUserPassword) ?? "";
    }else{
      return sharedPreferences.getString(AppConstants.userPassword) ?? "";
    }
  }



  @override
  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences.remove(AppConstants.userPassword);
    return await sharedPreferences.remove(AppConstants.userNumber);
  }

  @override
  bool clearSharedAddress(){
    sharedPreferences.remove(AppConstants.userAddress);
    return true;
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset = 1}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(value, {int? id}) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future permanentlyDelete() async{
    return await apiClient.postData(AppConstants.deleteAccount, {});
  }

  @override
  Future<void> saveRideCreatedTime(DateTime dateTime) async {
    await sharedPreferences.setString('DateTime', dateTime.toString());
  }

  @override
  Future<String> remainingTime() async{
    return  sharedPreferences.getString('DateTime') ?? '';
  }
}
