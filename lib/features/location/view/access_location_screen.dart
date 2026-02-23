import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/loader_widget.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/dashboard/controllers/bottom_menu_controller.dart';
import 'package:ride_sharing_user_app/features/address/domain/models/address_model.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/location/view/pick_map_screen.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';

class AccessLocationScreen extends StatelessWidget {
  const AccessLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: BodyWidget(
          appBar: AppBarWidget(title: 'set_location'.tr,showBackButton: false),
          body: Center(child: GetBuilder<LocationController>(builder: (locationController) {
            return SizedBox(width: 700, child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(Images.mapLocationIcon, height: 240),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Text(
                    'find_driver_near_you'.tr,
                    textAlign: TextAlign.center,
                    style: textMedium.copyWith(
                      fontSize: Dimensions.fontSizeExtraLarge,
                      color:Get.isDarkMode ?
                      Theme.of(context).primaryColorLight :
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    child: Text(
                      'please_select_you_location_to_start_finding_available_driver_near_you'.tr,
                      textAlign: TextAlign.center,
                      style: textRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color:Get.isDarkMode ? Theme.of(context).primaryColorLight :
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  const BottomButton(),

                ],
              ),
            ));
          })),
        ),
      ),
    );
  }
}

class BottomButton extends StatelessWidget {
  const BottomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: SizedBox(width: MediaQuery.of(context).size.width-40, child: Column(children: [
      ButtonWidget(
        buttonText: 'use_current_location'.tr,
        fontSize: Dimensions.fontSizeSmall,
        onPressed: () async {
          if(GetPlatform.isIOS) {
            saveAndNavigate();
          }else{
            Get.find<LocationController>().checkPermission(() async {
              saveAndNavigate();
            });
          }
        }, icon: Icons.my_location,
      ),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      ButtonWidget(buttonText: 'set_from_map'.tr,
        fontSize: Dimensions.fontSizeSmall,
        onPressed: ()=> Get.to(() =>  const PickMapScreen(type: LocationType.accessLocation)),
      ),
      const SizedBox(height: Dimensions.paddingSizeSmall),

    ])));
  }

  void saveAndNavigate() async {
    Get.dialog(const LoaderWidget(), barrierDismissible: false);
    Address? address = await Get.find<LocationController>().getCurrentLocation();
    if(address != null) {
      await Get.find<LocationController>().saveUserAddress(address);
      Get.find<BottomMenuController>().navigateToDashboard();
    }else{
      Get.back();
      bool isLocationServiceEnable = await Geolocator.isLocationServiceEnabled();
      if(isLocationServiceEnable){
        showCustomSnackBar('service_not_available'.tr);
      }else{
        showCustomSnackBar('your_location_access_first'.tr);
      }
    }
  }

}

