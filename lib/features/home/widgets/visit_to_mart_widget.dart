import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:url_launcher/url_launcher.dart';

class VisitToMartWidget extends StatelessWidget {
  const VisitToMartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: Get.width,height: Get.height * 0.1,
      child: InkWell(
        onTap: () async{
          navigateToMartApp();
        },
        child: Stack(children: [
          Image.asset(Images.visitMartBg,width: Get.width,height: Get.height * 0.1,fit: BoxFit.fitWidth),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(child: Text('${'enjoy_unlimited_shopping'.tr} ${Get.find<ConfigController>().config?.martBusinessName}')),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              ButtonWidget(
                  width: Get.width * 0.15,height: 30,
                  onPressed: (){
                    navigateToMartApp();
                  },
                  buttonText: 'visit'.tr
              )
            ]),
          )
        ]),
      ),
    );
  }

  void navigateToMartApp() async{
    String url = 'sixammart://open?country_code=${Get.find<AuthController>().getLoginCountryCode(true)}&phone=${Get.find<AuthController>().getUserNumber(true)}&password=${Get.find<AuthController>().getUserToken()}';
    if(GetPlatform.isAndroid){
      try{
        await launchUrl(Uri.parse(url));
      }catch(exception){
        navigateToStores(url);
      }
    }else if(GetPlatform.isIOS){
      if(await launchUrl(Uri.parse(url))){}else{
        navigateToStores(url);
      }
    }
  }

  void navigateToStores(String url) async{
    if(GetPlatform.isAndroid && Get.find<ConfigController>().config?.martPlayStoreUrl != null){
      await launchUrl(Uri.parse(Get.find<ConfigController>().config!.martPlayStoreUrl!));
    }else if(GetPlatform.isIOS && Get.find<ConfigController>().config?.martAppStoreUrl != null){
      await launchUrl(Uri.parse(Get.find<ConfigController>().config!.martAppStoreUrl!));
    }else{
      showCustomSnackBar('contact_with_support'.tr);
    }
  }
}
