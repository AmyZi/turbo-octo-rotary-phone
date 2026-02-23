import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/helper/login_helper.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final Map<String,dynamic>? notificationData;
  final String? userName;
  const LanguageSelectionScreen({super.key, required this.userName, required this.notificationData});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {

  @override
  void initState() {
    _loadDate();
    super.initState();
  }

  void _loadDate()async{
    await FirebaseMessaging.instance.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        body: GetBuilder<LocalizationController>(builder: (localizationController){
          return Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              const SizedBox(height: 40),

              Text('select_language'.tr, style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Text('choose_your_language_to_proceed'.tr, style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),

              Flexible(
                child: ListView.builder(
                    itemCount: AppConstants.languages.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index){
                      return InkWell(onTap: (){
                        localizationController.setSelectIndex(index);
                      },
                        child: Container(
                          decoration: BoxDecoration(
                              color: localizationController.selectIndex == index ? Theme.of(context).primaryColor.withValues(alpha:0.05) : null,
                              borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                              border: localizationController.selectIndex == index ? Border.all(width: 0.5,color: Theme.of(context).primaryColor) : null
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                            child: Row(children: [
                              Image.asset(AppConstants.languages[index].imageUrl,height: 26,width: 26),

                              const SizedBox(width:Dimensions.paddingSizeExtraSmall),
                              Text('${AppConstants.languages[index].countryCode} (${AppConstants.languages[index].languageName})',style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                            ]),
                          ),
                        ),
                      );
                    }),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              localizationController.isLoading ?
              Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0)) :
              ButtonWidget(
                  onPressed: (){
                    localizationController.setLanguage(Locale(AppConstants.languages[localizationController.selectIndex].languageCode, AppConstants.languages[localizationController.selectIndex].countryCode));
                    if(Get.find<AuthController>().isLoggedIn()) {
                      LoginHelper().forLoginUserRoute(widget.notificationData, widget.userName);
                    }else{
                      LoginHelper().forNotLoginUserRoute(widget.notificationData, widget.userName);
                    }
                  },
                  buttonText: 'select'.tr
              )

            ])),
          );
        }),
      ),
    );
  }
}
