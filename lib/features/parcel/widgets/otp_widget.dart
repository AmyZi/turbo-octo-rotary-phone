import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/map/widget/otp_car_bike_animated_widget.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';


class OtpWidget extends StatefulWidget {
  final bool isParcel;
  const OtpWidget({super.key, required this.isParcel});

  @override
  State<OtpWidget> createState() => _OtpWidgetState();
}

class _OtpWidgetState extends State<OtpWidget> {
  bool isAnimated = true;

  @override
  void initState() {
    if(widget.isParcel){
      Future.delayed(const Duration(seconds: 5)).then((_) {
        isAnimated = false;
        setState(() {});
      });
    }else{
      isAnimated = false;
      setState(() {});
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (rideController) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
        child: Column(children: [
          if(isAnimated && widget.isParcel)
            const OtpCarBikeAnimatedWidget(),

          if(!isAnimated)...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                  ),
                  child: Center(child: Text(
                    '${rideController.tripDetails?.otp?[0]}',
                    style: textBold.copyWith(fontSize: 28, color: Theme.of(context).textTheme.bodyMedium?.color),
                  )),
                ),

                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                  ),
                  child: Center(child: Text(
                    '${rideController.tripDetails?.otp?[1]}',
                    style: textBold.copyWith(fontSize: 28, color: Theme.of(context).textTheme.bodyMedium?.color),
                  )),
                ),

                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                  ),
                  child: Center(child: Text(
                    '${rideController.tripDetails?.otp?[2]}',
                    style: textBold.copyWith(fontSize: 28, color: Theme.of(context).textTheme.bodyMedium?.color),
                  )),
                ),

                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                  ),
                  child: Center(child: Text(
                    '${rideController.tripDetails?.otp?[3]}',
                    style: textBold.copyWith(fontSize: 28, color: Theme.of(context).textTheme.bodyMedium?.color),
                  )),
                )
              ]),
            ),

            Text.rich(TextSpan(
                style: textRegular.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.8),
                ), children: [
              TextSpan(
                text: 'please'.tr,
                style: textRegular.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.8),
                  fontSize: Dimensions.fontSizeDefault,
                ),
              ),

              TextSpan(
                text: 'share_the_pin'.tr,
                style: textSemiBold.copyWith(
                  color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault,
                ),
              ),

              TextSpan(
                text: 'with_the_driver'.tr,
                style: textRegular.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.8),
                  fontSize: Dimensions.fontSizeDefault,
                ),
              ),
            ]), textAlign: TextAlign.center),

            const SizedBox(height: Dimensions.paddingSizeExtraLarge),
          ]
        ]),
      );
    });
  }
}
