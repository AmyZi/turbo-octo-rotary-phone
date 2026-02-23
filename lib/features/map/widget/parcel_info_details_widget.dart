
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/fare_input_widget.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/product_details_widget.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/user_details_widget.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/route_widget.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/tolltip_widget.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/who_will_pay_button.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ParcelInfoDetailsWidget extends StatefulWidget {
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  const ParcelInfoDetailsWidget({super.key, required this.expandableKey});

  @override
  State<ParcelInfoDetailsWidget> createState() => _ParcelInfoDetailsWidgetState();
}

class _ParcelInfoDetailsWidgetState extends State<ParcelInfoDetailsWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParcelController>(builder: (parcelController){
      return GetBuilder<RideController>(builder: (rideController){
        return Column(mainAxisSize: MainAxisSize.min,children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const TollTipWidget(title: "delivery_details", showInsight: false),

            if(rideController.parcelEstimatedFare?.data?.couponApplicable ?? false)
              Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeSmall,
                    vertical: Dimensions.paddingSizeExtraSmall,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha:0.15),
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                  ),
                  child: Text(
                    'coupon_applied'.tr,
                    style: textBold.copyWith(color: Theme.of(context).primaryColor),
                  )
              ),
          ]),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          RouteWidget(
            totalDistance: Get.find<RideController>().parcelEstimatedFare!.data!.estimatedDistance!.toString(),
            fromAddress: Get.find<ParcelController>().senderAddressController.text,
            toAddress: Get.find<ParcelController>().receiverAddressController.text,
            extraOneAddress: '', extraTwoAddress: '', entrance: '',
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),


          const ProductDetailsWidget(),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          WhoWillPayButton(expandableKey: widget.expandableKey),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          UserDetailsWidget(
            name: parcelController.senderNameController.text,
            contactNumber: parcelController.senderContactController.text,
            type: 'sender',
          ),

          UserDetailsWidget(
            name: parcelController.receiverNameController.text,
            contactNumber: parcelController.receiverContactController.text,
            type: 'receiver',
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          if(rideController.parcelEstimatedFare?.data?.extraFareReason != '') ...[
            Text('${'fares_are_a_bit_higher'.tr}${rideController.parcelEstimatedFare?.data?.extraFareReason}', style: textRegular.copyWith(color: Theme.of(context).colorScheme.inverseSurface,fontSize: 11), textAlign: TextAlign.center),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          ],

          FareInputWidget(
            expandableKey: widget.expandableKey,fromRide: false,
            fare: (((rideController.parcelEstimatedFare!.data!.extraFareFee ?? 0) > 0) || ((rideController.parcelEstimatedFare!.data!.surgeMultiplier ?? 0) > 0)) ?
            rideController.parcelEstimatedFare!.data!.extraEstimatedFare.toString() :
            rideController.parcelEstimatedFare!.data!.estimatedFare.toString(),

            discountAmount: (((rideController.parcelEstimatedFare!.data!.extraFareFee ?? 0) > 0) || ((rideController.parcelEstimatedFare!.data!.surgeMultiplier ?? 0) > 0)) ?
            rideController.parcelEstimatedFare!.data!.extraDiscountAmount :
            rideController.parcelEstimatedFare!.data!.discountAmount ,

            discountFare: (((rideController.parcelEstimatedFare!.data!.extraFareFee ?? 0) > 0) || ((rideController.parcelEstimatedFare!.data!.surgeMultiplier ?? 0) > 0)) ?
            rideController.parcelEstimatedFare!.data!.extraDiscountFare :
            rideController.parcelEstimatedFare!.data!.discountFare ,

          ),

        ]);
      });
    });
  }

}
