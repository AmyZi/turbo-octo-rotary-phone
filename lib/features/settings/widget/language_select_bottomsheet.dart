import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class LanguageSelectBottomSheet extends StatelessWidget {
  const LanguageSelectBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
      return GetBuilder<LocalizationController>(builder: (localizationController){
        return PopScope(onPopInvokedWithResult: (didPop, val){
          localizationController.setInitialIndex();
        },
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Container(width: double.infinity,padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
                child: Column(children: [
                  Image.asset(Images.smallIcon,height: 10,width: 40,),
            
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                  Text('select_language'.tr,style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge),),
            
                  const SizedBox(height: Dimensions.paddingSizeSmall,),
                  Text('choose_your_language_to_processed'.tr,style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall),),
            
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  ListView.builder(
                    itemCount: AppConstants.languages.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
            
                              const SizedBox(width:Dimensions.paddingSizeExtraSmall ,),
                              Text('${AppConstants.languages[index].countryCode} (${AppConstants.languages[index].languageName})',style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                            ]),
                          ),
                        ),
                      );
                    }),
            
                 const SizedBox(height: Dimensions.paddingSizeDefault,),
                  ButtonWidget(buttonText: 'update'.tr,backgroundColor: Theme.of(context).primaryColor, onPressed: (){
                    localizationController.setLanguage(Locale(AppConstants.languages[localizationController.selectIndex].languageCode, AppConstants.languages[localizationController.selectIndex].countryCode));
                    Get.back();
                  },)
                ]),
              ),
            ),
          ),
        );
      });
  }
}
