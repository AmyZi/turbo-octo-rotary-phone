import 'dart:convert';

import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/address/domain/models/address_model.dart';
import 'package:ride_sharing_user_app/localization/language_model.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart' as intl;

class LocalizationController extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;

  LocalizationController({required this.sharedPreferences}) {
    loadCurrentLanguage();
  }

  Locale _locale = Locale(AppConstants.languages[0].languageCode, AppConstants.languages[0].countryCode);
  bool _isLtr = true;
  int _selectIndex = 0;
  List<LanguageModel> _languages = [];

  Locale get locale => _locale;
  bool get isLtr => _isLtr;
  int get selectIndex => _selectIndex;
  List<LanguageModel> get languages => _languages;
  bool isLoading = false;

  void setLanguage(Locale locale) {
    Get.updateLocale(locale);
    _locale = locale;
    _isLtr = !intl.Bidi.isRtlLanguage(_locale.languageCode);
    saveLanguage(_locale);
    isLoading = true;
    update();

    Address? address;
    try {
      address = Address.fromJson(jsonDecode(sharedPreferences.getString(AppConstants.userAddress)!));
      // ignore: empty_catches
    }catch(e) {
    }
    Get.find<ApiClient>().updateHeader(sharedPreferences.getString(AppConstants.token) ?? '', address);
    backendLanguageUpdate();
  }

  void loadCurrentLanguage() async {
    if(sharedPreferences.containsKey(AppConstants.languageCode)){
      _locale = Locale(sharedPreferences.getString(AppConstants.languageCode)!,
          sharedPreferences.getString(AppConstants.countryCode));
      _isLtr = !intl.Bidi.isRtlLanguage(_locale.languageCode);
      update();
    }
  }

  void saveLanguage(Locale locale) async {
    sharedPreferences.setString(AppConstants.languageCode, locale.languageCode);
    sharedPreferences.setString(AppConstants.countryCode, locale.countryCode!);
    update();
  }

  void setSelectIndex(int index) {
    _selectIndex = index;
    update();
  }

  void searchLanguage(String query, BuildContext context) {
    if (query.isEmpty) {
      _languages.clear();
      _languages = AppConstants.languages;
      update();
    } else {
      _selectIndex = -1;
      _languages = [];
      for (LanguageModel language in AppConstants.languages) {
        if (language.languageName.toLowerCase().contains(query.toLowerCase())) {
          _languages.add(language);
        }
      }
      update();
    }
  }

  void initializeAllLanguages(BuildContext context) {
    if (_languages.isEmpty) {
      _languages.clear();
      _languages = AppConstants.languages;
    }
  }

  void setInitialIndex(){
    for(int i = 0; i < AppConstants.languages.length; i++){
      if(locale.languageCode == AppConstants.languages[i].languageCode){
        _selectIndex = i;
      }
    }
  }

  void backendLanguageUpdate(){
    Get.find<ApiClient>().postData(AppConstants.changeLanguage, {});
  }

  bool haveLocalLanguageCode() {
    if(sharedPreferences.containsKey(AppConstants.languageCode)) {
      return true;
    }else{
      return false;
    }
  }

}
