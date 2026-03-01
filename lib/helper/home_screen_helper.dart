

import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/maintainance_mode/maintainance_screen.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';

class HomeScreenHelper{

  static void checkMaintanceMode(){

    int parcelCount = Get.find<ParcelController>().parcelListModel?.totalSize ?? 0;
    int rideCount = (
        Get.find<RideController>().rideDetails != null &&
            Get.find<RideController>().rideDetails!.type != 'parcel' &&
            (
                Get.find<RideController>().rideDetails!.currentStatus == 'pending' ||
                    Get.find<RideController>().rideDetails!.currentStatus == 'accepted'||
                    Get.find<RideController>().rideDetails!.currentStatus == 'ongoing' ||
                    (
                        Get.find<RideController>().rideDetails!.currentStatus == 'completed' &&
                            Get.find<RideController>().rideDetails!.paymentStatus! == 'unpaid'
                    ) ||
                    (
                        Get.find<RideController>().rideDetails!.currentStatus == 'cancelled' &&
                            Get.find<RideController>().rideDetails!.paymentStatus! == 'unpaid'
                    )
            )
    ) ? 1 : 0 ;

    if(rideCount == 0 && parcelCount == 0){
      Get.find<ConfigController>().saveOngoingRides(false);
      if(Get.find<ConfigController>().config!.maintenanceMode != null &&
          Get.find<ConfigController>().config!.maintenanceMode!.maintenanceStatus == 1 &&
          Get.find<ConfigController>().config!.maintenanceMode!.selectedMaintenanceSystem!.userApp == 1
      ){
        Get.offAll(() => const MaintenanceScreen());
      }
    }else{
      Get.find<ConfigController>().saveOngoingRides(true);
    }
  }

}