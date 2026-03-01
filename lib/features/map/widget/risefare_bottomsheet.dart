import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/route_widget.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/tolltip_widget.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/ride/widgets/rise_fare_widget.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';


class RaiseFareBottomSheet extends StatefulWidget {
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  const RaiseFareBottomSheet({super.key, required this.expandableKey});

  @override
  State<RaiseFareBottomSheet> createState() => _RaiseFareBottomSheetState();
}

class _RaiseFareBottomSheetState extends State<RaiseFareBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (rideController){
      return GetBuilder<LocationController>(builder: (locationController){
        return Column(children: [
          TollTipWidget(title: 'trip_details'.tr),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          RouteWidget(
              totalDistance: rideController.tripDetails == null ? rideController.estimatedDistance : rideController.tripDetails!.estimatedDistance!.toString(),
              fromAddress: rideController.tripDetails == null ? locationController.fromAddress?.address??'' : rideController.tripDetails!.pickupAddress ?? '',
              extraOneAddress: locationController.extraRouteAddress?.address ?? '',
              extraTwoAddress: locationController.extraRouteTwoAddress?.address ?? '',
              toAddress: rideController.tripDetails == null ? locationController.toAddress?.address??'' : rideController.tripDetails!.destinationAddress ?? '',
              entrance: rideController.tripDetails == null ? locationController.entranceController.text : rideController.tripDetails!.entrance ?? '',
          ),

          Divider(color: Theme.of(context).primaryColor.withValues(alpha:0.15)),

          RiseFareWidget(expandableKey: widget.expandableKey, fromPage: RiseFare.ride),
          const SizedBox(height: Dimensions.paddingSizeDefault),
        ]);
      });
    });
  }
}
