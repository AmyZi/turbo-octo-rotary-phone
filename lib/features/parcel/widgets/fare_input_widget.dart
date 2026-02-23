import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/ride/widgets/trip_fare_summery.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';

class FareInputWidget extends StatefulWidget {
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  final bool fromRide;
  final String fare;
  final double? discountAmount;
  final double? discountFare;
  const FareInputWidget({super.key, required this.fromRide, required this.fare, required this.expandableKey,this.discountAmount,this.discountFare});

  @override
  State<FareInputWidget> createState() => _FareInputWidgetState();
}

class _FareInputWidgetState extends State<FareInputWidget> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (rideController) {
      return GetBuilder<ParcelController>(builder: (parcelController) {
        return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          widget.fromRide ?
          Expanded(child: GestureDetector(
            onTap: () {
              if(widget.fromRide) {
                Get.find<RideController>().updateRideCurrentState(RideState.riseFare);
              }
              Get.find<MapController>().notifyMapController();
            },
            child: Container(height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                border: Border.all(color: Theme.of(context).primaryColor,width: 1),
              ),
              child: Center(child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                    child: Text(
                      'fare'.tr,
                      overflow: TextOverflow.ellipsis,
                      style: textRegular.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha:0.9),
                      ),
                    ),
                  )),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                    child: Text(
                      PriceConverter.convertPrice(
                        (widget.discountAmount ?? 0) > 0 ?
                        widget.discountFare! : double.tryParse(widget.fare)!,
                      ),
                      style: textRobotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha:0.9),
                      ),
                    ),
                  ),

                ],
              )),
            ),
          )) :
          const SizedBox(),
          if(widget.fromRide)
          const SizedBox(width: Dimensions.paddingSizeSmall),

          (rideController.isSubmit || parcelController.getSuggested) ?
          Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0)) :
          Expanded(
            child:  rideController.isSubmit ?
            Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0)) :
            Column(children: [
              if(!widget.fromRide) ...[
                Divider(color: Theme.of(context).hintColor.withValues(alpha:0.5)),

                TripFareSummery(
                  tripFare: double.tryParse(widget.fare)!, fromParcel: false,
                  discountFare: widget.discountFare!,
                  discountAmount: widget.discountAmount,
                ),

                const SizedBox(height: Dimensions.paddingSizeSmall),
              ],

              ButtonWidget(
                buttonText: widget.fromRide ? 'find_rider'.tr : 'find_deliveryman'.tr,
                onPressed: () {
                  if(widget.fromRide) {
                    rideController.submitRideRequest(rideController.noteController.text, false).then((value) {
                      if(value.statusCode == 200) {
                        Get.find<AuthController>().saveFindingRideCreatedTime();
                        rideController.updateRideCurrentState(RideState.findingRider);
                        Get.find<MapController>().initializeData();
                        Get.find<MapController>().setOwnCurrentLocation(
                            LatLng(
                                Get.find<LocationController>().fromAddress?.latitude ?? 0,
                                Get.find<LocationController>().fromAddress?.longitude ?? 0
                            )
                        );
                        Get.find<MapController>().notifyMapController();
                      }
                    });
                  }else {
                    parcelController.getSuggestedCategoryList().then((value) {
                      if(value.statusCode == 200){
                        Get.find<AuthController>().saveFindingRideCreatedTime();
                        Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.suggestVehicle);
                        Get.find<ParcelController>().focusOnBottomSheet(widget.expandableKey);
                      }
                    });
                  }
                  Get.find<MapController>().notifyMapController();
                },
                fontSize: Dimensions.fontSizeDefault,
              ),
            ]),
          ),
        ]);
      });
    });
  }
}
