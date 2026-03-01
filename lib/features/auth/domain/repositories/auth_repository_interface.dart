import 'package:ride_sharing_user_app/features/auth/domain/models/sign_up_body.dart';
import 'package:ride_sharing_user_app/interface/repository_interface.dart';

abstract class AuthRepositoryInterface implements RepositoryInterface{

  Future<dynamic> login({required String phone, required String password});
  Future<dynamic> externalLogin({required String phone, required String password});
  Future<dynamic> logOut();
  Future<dynamic> registration({required SignUpBody signUpBody});
  Future<dynamic> sendOtp({required String phone});
  Future<dynamic> isUserRegistered({required String phone});
  Future<dynamic> verifyOtp({required String phone, required String otp});
  Future<dynamic> otpLogin({required String phone, required String otp});
  Future<dynamic> resetPassword(String phoneOrEmail, String password);
  Future<dynamic> verifyFirebaseOtp({required String phone, required String otp, required String session});
  Future<dynamic> changePassword(String oldPassword, String password);
  Future<dynamic> updateToken();
  Future<dynamic> forgetPassword(String? phone);
  Future<dynamic> verifyToken(String phone, String otp);
  Future<dynamic> checkEmail(String email);
  Future<dynamic> verifyEmail(String email, String token);
  Future<dynamic> verifyPhone(String phone, String otp);
  Future<bool?> saveUserToken(String token);
  String getUserToken();
  bool isLoggedIn();
  bool clearSharedData();
  Future<void> saveUserNumberAndPassword(String code, String number, String password, bool externalUser);
  String getUserNumber(bool externalUser);
  String getUserPassword(bool externalUser);
  Future<bool> clearUserNumberAndPassword();
  bool clearSharedAddress();
  Future<dynamic> permanentlyDelete();
  Future<void> saveRideCreatedTime(DateTime dateTime);
  Future<String> remainingTime();
  String getLoginCountryCode(bool externalUser);
}