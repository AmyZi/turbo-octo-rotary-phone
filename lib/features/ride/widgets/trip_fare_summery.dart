import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';
import 'package:ride_sharing_user_app/features/payment/widget/payment_item_info_widget.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/coupon/controllers/coupon_controller.dart';
import 'package:ride_sharing_user_app/features/payment/controllers/payment_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';

class TripFareSummery extends StatelessWidget {
  final bool fromPayment;
  final bool fromParcel;
  final double? tripFare;
  final double? discountFare;
  final double? discountAmount;
  const TripFareSummery({super.key, this.fromPayment = false,  this.tripFare, required this.fromParcel,this.discountFare,this.discountAmount});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (rideController) {
      return GetBuilder<CouponController>(builder: (couponController) {
        return GetBuilder<PaymentController>(builder: (paymentController) {
          double total = 0;
          if (fromPayment) {
            total = rideController.finalFare!.paidFare! + double.parse(paymentController.tipAmount);
          } else {
            total = rideController.tripDetails?.paidFare ?? 0;
          }
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
              color: fromPayment ? null : Theme.of(context).hintColor.withValues(alpha:0.07),
            ),
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Column(children: [
              if(!fromPayment)
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Row(children: [
                    Image.asset(Images.farePrice, height: 15, width: 15, color: Theme.of(context).textTheme.bodyMedium?.color),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Text('fare_price'.tr, style: textRegular.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: Dimensions.fontSizeDefault,
                    )),
                  ]),

                  Row(children: [
                    if(discountAmount != null && discountAmount!.toDouble() > 0)
                      Text(PriceConverter.convertPrice(tripFare!),
                        style: textRobotoBold.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).hintColor,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Theme.of(context).hintColor,
                        ),
                      ),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
                      ),
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                      child: Text(' ${PriceConverter.convertPrice(
                          discountAmount != null && discountAmount !.toDouble() > 0 ? discountFare! : tripFare!)}',
                        style: textRobotoBold.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),
                  ])
                ]),

              if(fromPayment)...[
                rideController.finalFare!.discountAmount!.toDouble() > 0 ?
                Padding(
                  padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                  child: Row(children: [
                    SizedBox(width: Dimensions.iconSizeSmall, child: Image.asset(
                      Images.farePrice, color: Theme.of(context).primaryColor,
                    )),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Expanded(child: Row(children: [
                      Text('fare_fee'.tr, style: textMedium.copyWith(
                        color: Theme.of(context).primaryColor,
                      )),

                      Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.error.withValues(alpha:0.10),
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeExtraSmall,
                          ),
                          margin: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                          child: Text(
                            (rideController.finalFare?.discount == null) && ((rideController.finalFare?.discountAmount ?? 0 ) > 0) ?
                            '${PriceConverter.convertPrice(rideController.finalFare!.discountAmount!.toDouble())} ${'off'.tr}' :
                            rideController.finalFare!.discount!.discountAmountType == 'percentage' ?
                            '${rideController.finalFare!.discount!.discountAmount}% ${'off'.tr}' :
                            '${PriceConverter.convertPrice(rideController.finalFare!.discount!.discountAmount!.toDouble())} ${'off'.tr}',
                            style: textRobotoRegular.copyWith(color: Theme.of(context).colorScheme.error),
                          )
                      )
                    ])),

                    Text(
                      PriceConverter.convertPrice(rideController.finalFare?.distanceWiseFare ?? 0),
                      style: textRobotoRegular.copyWith(
                        color: Theme.of(context).hintColor,
                        decorationColor: Theme.of(context).hintColor,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),

                    Text(
                      ' ${PriceConverter.convertPrice(
                          rideController.finalFare!.distanceWiseFare! -
                              rideController.finalFare!.discountAmount!)}',
                      style: textRobotoRegular.copyWith(color: Theme.of(context).primaryColor),
                    ),

                  ]),
                ) :

                PaymentItemInfoWidget(
                  icon: Images.farePrice,
                  title: 'fare_fee'.tr,
                  amount: rideController.finalFare?.distanceWiseFare ?? 0,
                ),
              ],

              if(fromPayment && !fromParcel && rideController.finalFare!.cancellationFee!.toDouble() > 0)
                PaymentItemInfoWidget(
                  icon: Images.idleHourIcon,
                  title: 'cancellation_price'.tr,
                  amount: rideController.finalFare?.cancellationFee ?? 0,
                ),

              if(fromPayment && !fromParcel && rideController.finalFare!.idleFee!.toDouble() > 0)
                PaymentItemInfoWidget(
                  icon: Images.idleHourIcon,
                  title: 'idle_price'.tr,
                  amount: rideController.finalFare?.idleFee ?? 0,
                ),

              if(fromPayment && !fromParcel && rideController.finalFare!.delayFee!.toDouble() > 0)
                PaymentItemInfoWidget(
                  icon: Images.waitingPrice,
                  title: 'delay_price'.tr,
                  amount: rideController.finalFare?.delayFee ?? 0,
                ),

              if(fromPayment && rideController.finalFare!.couponAmount!.toDouble() > 0)
                PaymentItemInfoWidget(
                  icon: Images.profileMyWallet,
                  title: 'coupon_discount'.tr,
                  amount: rideController.finalFare?.couponAmount ?? 0,
                  discount: true,
                ),

              if(fromPayment && rideController.finalFare!.vatTax!.toDouble() > 0)
                PaymentItemInfoWidget(
                  icon: Images.farePrice,
                  title: 'vat_tax'.tr,
                  amount: rideController.finalFare?.vatTax ?? 0,
                ),

              if(fromPayment && double.parse(paymentController.tipAmount) > 0)
                PaymentItemInfoWidget(
                  icon: Images.farePrice, title: 'tips'.tr,
                  amount: double.parse(paymentController.tipAmount),
                  toolTipText: 'tips_tooltip',
                ),

              if(fromPayment)
                PaymentItemInfoWidget(title: 'sub_total'.tr, amount: total, isSubTotal: true),

              if(!fromPayment)
                const SizedBox(height: Dimensions.paddingSizeSmall),

              if(fromPayment)
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              if(!fromPayment)
                GetBuilder<ParcelController>(builder: (parcelController) {
                  return !parcelController.payReceiver ?
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Expanded(child: Row(children: [
                      Image.asset(Images.paymentTypeIcon, height: 15, width: 15, color: Theme.of(context).textTheme.bodyMedium?.color),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Text('payment'.tr, style: textRegular.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: Dimensions.fontSizeDefault,
                      )),
                    ])),
                    SizedBox(
                      width: 120,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(
                          Dimensions.paddingSizeExtraSmall,
                        )),
                        child: DropdownButton<String>(
                          value: paymentController.paymentTypeIndex == 0 ?
                          'cash' :
                          paymentController.paymentTypeIndex == 1 ?
                          'digital' :
                          'wallet',
                          items: paymentController.paymentTypeList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value.tr,
                                style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault,color: Theme.of(context).primaryColor),
                                textAlign: TextAlign.right,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if(value == 'wallet' &&
                                (discountAmount != null && discountAmount!.toDouble() > 0 ? discountFare! : tripFare!) > Get.find<ProfileController>().profileModel!.data!.wallet!.walletBalance!
                            ){
                              showCustomSnackBar(
                                 'your_wallet_has_insufficient_balance'.tr,
                                isError: true,
                                subMessage: '${'wallet_balance'.tr}: ${PriceConverter.convertPrice(Get.find<ProfileController>().profileModel!.data!.wallet!.walletBalance!)}'
                              );
                            }else{
                               paymentController.setPaymentType(value == 'cash' ? 0 : value == 'digital' ? 1 : 2);
                            }
                          },
                          isExpanded: true,
                          underline: const SizedBox(),
                          iconEnabledColor: Theme.of(context).primaryColor,
                          icon: Icon(Icons.keyboard_arrow_down_rounded),
                        ),
                      ),
                    )
                  ]) :
                  const SizedBox();
                })

            ]),
          );
        });
      });
    });
  }
}
