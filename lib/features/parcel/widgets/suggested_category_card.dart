import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/parcel/domain/models/suggested_vehicle_category_model.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/route_widget.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';

class SuggestedCategoryCard extends StatelessWidget {
  final SuggestedCategory suggestedCategory;
  const SuggestedCategoryCard({super.key, required this.suggestedCategory});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GetBuilder<RideController>(builder: (rideController){
        return InkWell(
          onTap: () {
            if(!rideController.isSubmit){
              Get.find<RideController>().submitRideRequest('', true, categoryId: suggestedCategory.id!).then((value) {
                if(value.statusCode == 200) {
                  Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.findingRider);
                  Get.find<MapController>().notifyMapController();
                }
              });
            }
          },
          child: Container(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withValues(alpha:.2), spreadRadius: 1, blurRadius: 1, offset: const Offset(1,1))]),
            child: Column(children: [

              Row(children: [
                Expanded(child: Text(suggestedCategory.name!, style: textMedium.copyWith(color: Theme.of(context).primaryColor),)),
                ImageWidget(image: '${Get.find<ConfigController>().config?.imageBaseUrl?.vehicleCategory}/${suggestedCategory.image}',
                    width: 50,height: 50, fit: BoxFit.contain),
              ]),

              RouteWidget(totalDistance: Get.find<RideController>().parcelEstimatedFare!.data!.estimatedDistance!.toString(),
                fromAddress: Get.find<ParcelController>().senderAddressController.text,
                toAddress: Get.find<ParcelController>().receiverAddressController.text,
                extraOneAddress: '', extraTwoAddress: '', entrance: '',
              ),

            ]),
          ),
        );
      }),
    );
  }
}
