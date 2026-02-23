import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/swipable_button_widget/slider_button_widget.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';


class ParcelReturningProcessWidget extends StatelessWidget {
  const ParcelReturningProcessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (rideController){
      return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha:0.05),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0,-4)
              )
            ]
        ),
        child: Column(children: [
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('parcel_returned_otp'.tr, style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),

              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
                ),
                padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                child: Text('${rideController.tripDetails?.otp?[0]}${rideController.tripDetails?.otp?[1]}${rideController.tripDetails?.otp?[2]}${rideController.tripDetails?.otp?[3]}',style: textBold.copyWith(fontSize: 20)),
              ),
            ]),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          rideController.isLoading ?
          SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0) :
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Center(child: SliderButton(
              action: (){
                rideController.parcelReturned(rideController.tripDetails?.id ?? '').then((value){
                  if(value.statusCode == 200){
                    showDialog(context: Get.context!, builder: (_){
                      return parcelReceivedDialog(context);
                    });
                  }
                });
              },
              label: Text('parcel_received'.tr,style: TextStyle(color: Theme.of(context).primaryColor)),
              dismissThresholds: 0.5, dismissible: false, shimmer: false,
              width: 1170, height: 40, buttonSize: 40, radius: 20,
              icon: Center(child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).cardColor),
                child: Center(child: Icon(
                  Get.find<LocalizationController>().isLtr ? Icons.arrow_forward_ios_rounded : Icons.keyboard_arrow_left,
                  color: Colors.grey, size: 20.0,
                )),
              )),
              isLtr: Get.find<LocalizationController>().isLtr,
              boxShadow: const BoxShadow(blurRadius: 0),
              buttonColor: Colors.transparent,
              backgroundColor: Theme.of(context).primaryColor.withValues(alpha:0.15),
              baseColor: Theme.of(context).primaryColor,
            )),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge)


        ]),
      );
    });
  }
}

Widget parcelReceivedDialog(BuildContext context){
  return Dialog(
    surfaceTintColor: Get.isDarkMode ? Theme.of(context).hintColor  : Theme.of(context).cardColor,
    insetPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault)),
    child: Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: SizedBox(
        width: Get.width,
        child: Column(mainAxisSize:MainAxisSize.min, children: [
          Align(
            alignment: Alignment.topRight,
            child: InkWell(onTap: ()=> Get.back(), child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha:0.2),
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              child: Image.asset(
                Images.crossIcon,
                height: Dimensions.paddingSizeSmall,
                width: Dimensions.paddingSizeSmall,
                color: Theme.of(context).cardColor,
              ),
            )),
          ),

          Image.asset(Images.parcelReturnSuccessIcon,height: 80,width: 80),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.2),
            child: Text(
              'your_parcel_returned_successfully'.tr,
              style: textSemiBold.copyWith(color: Theme.of(context).primaryColor),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge)

        ]),
      ),
    ),
  );
}

