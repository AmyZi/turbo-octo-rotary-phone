import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/payment/widget/payment_item_info_widget.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';
import 'package:ride_sharing_user_app/features/trip/screens/schedule_trip_map_view.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/rider_info.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/trip_route_widget.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class TripDetailWidget extends StatelessWidget {
  final TripDetails tripDetails;
  const TripDetailWidget({super.key,required this.tripDetails});

  @override
  Widget build(BuildContext context) {
    String firstRoute = '';
    String secondRoute = '';
    List<dynamic> extraRoute = [];
    if(tripDetails.intermediateAddresses != null && tripDetails.intermediateAddresses != '[[, ]]'){
      extraRoute = jsonDecode(tripDetails.intermediateAddresses!);
      if(extraRoute.isNotEmpty){
        firstRoute = extraRoute[0];
      }
      if(extraRoute.isNotEmpty && extraRoute.length>1){
        secondRoute = extraRoute[1];
      }
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('trip_details'.tr, style: textBold.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            )),

            if(tripDetails.type == AppConstants.scheduleRequest && (tripDetails.currentStatus == AppConstants.pending || tripDetails.currentStatus == AppConstants.accepted))
              InkWell(
                onTap: () => Get.to(() => ScheduleTripMapView(tripDetails: tripDetails)),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                      border: Border.all(color: Theme.of(context).primaryColor)
                  ),
                  padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
                  child: Row(spacing: Dimensions.paddingSizeSmall, children: [
                    Image.asset(Images.routeIcon, height: 16, width: 16),

                    Text('map'.tr)
                  ]),
                ),
              )
          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2))
            ),
            padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: TripRouteWidget(
              pickupAddress: tripDetails.pickupAddress!,
              destinationAddress: tripDetails.destinationAddress!,
              extraOne: firstRoute,extraTwo: secondRoute,entrance: tripDetails.entrance,
            ),
          ),
        ]),
      ),

      if(tripDetails.driver != null) ...[
        RiderInfo(tripDetails: tripDetails),
        const SizedBox(height: Dimensions.paddingSizeSmall)
      ],

      Row(spacing: Dimensions.paddingSizeExtraSmall, children: [
        Text('billing_summery'.tr, style: textSemiBold),

        if(tripDetails.currentStatus == AppConstants.pending || tripDetails.currentStatus == AppConstants.accepted)
          Text('(${'estimated'.tr})'.tr, style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6))),
      ]),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          border: Border.all(color: Theme.of(context).hintColor.withValues(alpha:0.2)),
        ),
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(children: [
          PaymentItemInfoWidget(icon: Images.farePrice,title: 'fare_fee'.tr,amount: tripDetails.distanceWiseFare ?? 0),

          PaymentItemInfoWidget(icon: Images.idleHourIcon,title: 'idle_price'.tr,amount: tripDetails.idleFee ?? 0),

          PaymentItemInfoWidget(icon: Images.waitingPrice,title: 'delay_price'.tr,amount: tripDetails.delayFee ?? 0),

          PaymentItemInfoWidget(icon: Images.idleHourIcon,title: 'cancellation_price'.tr,amount: tripDetails.cancellationFee ?? 0),

          PaymentItemInfoWidget(icon: Images.coupon, title: 'coupon'.tr, amount: tripDetails.couponAmount ?? 0, discount: true),

          PaymentItemInfoWidget(icon: Images.discount, title: 'discount'.tr, amount: tripDetails.discountAmount ?? 0, discount: true),

          PaymentItemInfoWidget(icon: Images.farePrice,title: 'tips'.tr,amount: tripDetails.tips ?? 0),

          PaymentItemInfoWidget(icon: Images.farePrice,title: 'vat_tax'.tr,amount: tripDetails.vatTax ?? 0),

          Divider(color: Theme.of(context).hintColor.withValues(alpha:0.15)),

          PaymentItemInfoWidget(
            title: 'sub_total'.tr,
            amount: (tripDetails.type == AppConstants.scheduleRequest &&
                (tripDetails.currentStatus == AppConstants.pending ||  tripDetails.currentStatus == AppConstants.accepted)) ?
            tripDetails.distanceWiseFare ?? 0 : tripDetails.paidFare ?? 0,
            isSubTotal: true,
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              Image.asset(Images.profileMyWallet,height: 15,width: 15, color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7)),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Text('payment'.tr,style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color,fontSize: Dimensions.fontSizeSmall)),
            ]),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                tripDetails.paymentMethod!.tr,
                style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
            ),
          ])
        ]),
      )
    ]);
  }
}
