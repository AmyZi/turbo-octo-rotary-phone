import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/splash/domain/repositories/config_repository_interface.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigRepository implements ConfigRepositoryInterface{
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  const ConfigRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future<Response> getConfigData() {
    return apiClient.getData(AppConstants.configUri);
  }

  @override
  Future<bool> initSharedData() {
    if(!sharedPreferences.containsKey(AppConstants.theme)) {
      return sharedPreferences.setBool(AppConstants.theme, false);
    }
    if(!sharedPreferences.containsKey(AppConstants.countryCode)) {
      return sharedPreferences.setString(AppConstants.countryCode, AppConstants.languages[0].countryCode);
    }

    if(!sharedPreferences.containsKey(AppConstants.intro)) {
      sharedPreferences.setBool(AppConstants.intro, true);
    }
    return Future.value(true);
  }

  @override
  Future<bool> removeSharedData() {
    return sharedPreferences.clear();
  }

  @override
  void disableIntro() {
    sharedPreferences.setBool(AppConstants.intro, false);
  }

  @override
  bool? showIntro() {
    if(!sharedPreferences.containsKey(AppConstants.intro)) {
      sharedPreferences.setBool(AppConstants.intro, true);
    }
    return sharedPreferences.getBool(AppConstants.intro);

  }

  @override
  bool haveOngoingRides(){
    return sharedPreferences.getBool(AppConstants.haveOngoingRides) ?? false;
  }

  @override
  void saveOngoingRides(bool value) {
    sharedPreferences.setBool(AppConstants.haveOngoingRides, value);
  }

}