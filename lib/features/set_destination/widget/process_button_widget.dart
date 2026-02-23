import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/map/screens/map_screen.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';

class ProcessButtonWidget extends StatelessWidget {
  final FocusNode pickLocationFocus;
  final FocusNode destinationLocationFocus;
  const ProcessButtonWidget({super.key, required this.pickLocationFocus, required this.destinationLocationFocus});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (rideController){
      return GetBuilder<LocationController>(builder: (locationController){
        return Container(
          color: Theme.of(context).cardColor,
          child: Column(mainAxisSize: MainAxisSize.min,children: [
            rideController.loading ?
            SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0) :
            ButtonWidget(
              onPressed: () {
                if(Get.find<ConfigController>().config!.maintenanceMode != null &&
                    Get.find<ConfigController>().config!.maintenanceMode!.maintenanceStatus == 1 &&
                    Get.find<ConfigController>().config!.maintenanceMode!.selectedMaintenanceSystem!.userApp == 1
                ){
                  showCustomSnackBar('maintenance_mode_on_for_ride'.tr,isError: true);
                }else{
                  if(locationController.fromAddress == null ||
                      locationController.fromAddress!.address == null ||
                      locationController.fromAddress!.address!.isEmpty) {
                    showCustomSnackBar('pickup_location_is_required'.tr);
                    FocusScope.of(context).requestFocus(pickLocationFocus);
                  }else if(locationController.pickupLocationController.text.isEmpty) {
                    showCustomSnackBar('pickup_location_is_required'.tr);
                    FocusScope.of(context).requestFocus(pickLocationFocus);
                  }else if(locationController.toAddress == null ||
                      locationController.toAddress!.address == null ||
                      locationController.toAddress!.address!.isEmpty) {
                    showCustomSnackBar('destination_location_is_required'.tr);
                    FocusScope.of(context).requestFocus(destinationLocationFocus);
                  }else if(locationController.destinationLocationController.text.isEmpty) {
                    showCustomSnackBar('destination_location_is_required'.tr);
                    FocusScope.of(context).requestFocus(destinationLocationFocus);
                  }else{
                    rideController.getEstimatedFare(false).then((value) {
                      if(value.statusCode == 200) {
                        Get.to(() => const MapScreen(
                          fromScreen: MapScreenType.ride,
                          isShowCurrentPosition: false,
                        ));
                        Get.find<RideController>().updateRideCurrentState(RideState.initial);
                      }
                    });

                  }
                }
              },
              buttonText: 'proceed_to_next'.tr,
              margin: EdgeInsets.all(Dimensions.paddingSizeSmall),
              backgroundColor: _isProceedButtonActive(locationController) ?
              Theme.of(context).hintColor.withValues(alpha: 0.5) :
              Theme.of(context).primaryColor,
              radius: Dimensions.paddingSizeSmall,
            )
          ]),
        );
      });
    });
  }
}

bool _isProceedButtonActive(LocationController locationController){
  if(
  locationController.fromAddress == null || locationController.fromAddress!.address == null ||
      locationController.fromAddress!.address!.isEmpty || locationController.pickupLocationController.text.isEmpty ||
      locationController.toAddress == null || locationController.toAddress!.address == null ||
      locationController.toAddress!.address!.isEmpty || locationController.destinationLocationController.text.isEmpty
  ){
    return true;
  }else{
    return false;
  }
}