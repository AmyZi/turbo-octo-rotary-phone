import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/ride/widgets/rider_details_widget.dart';


class DriverRideRequestDialog extends StatelessWidget {
  final bool fromList;
  final String tripId;
  const DriverRideRequestDialog({super.key, required this.tripId,  this.fromList = false    });

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,0,Dimensions.paddingSizeDefault,0),
      child: GetBuilder<RideController>(builder: (rideController) {
        return rideController.biddingList.isNotEmpty ?
        Padding(padding: EdgeInsets.only(top: fromList? 0 : 100),
          child: Column(mainAxisSize: MainAxisSize.min, children:  [
            Flexible(
              child: Material(
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                color: Colors.transparent,
                child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ListView.builder(padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: rideController.biddingList.length,
                      addRepaintBoundaries: false,
                      addAutomaticKeepAlives: false,
                      itemBuilder: (context, index){
                        return RiderDetailsWidget(bidding: rideController.biddingList[index], tripId: tripId);
                      }
                  ),
                ),
              ),
            ),
          ]),
        ) :
        const SizedBox();
      }),
    );
  }
}
