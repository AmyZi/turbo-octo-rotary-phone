import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/set_destination/widget/schedule_date_time_picker_widget.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/helper/extensin_helper.dart';
import 'package:ride_sharing_user_app/helper/ride_controller_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';

class PickupTimeDateWidget extends StatelessWidget {
  const PickupTimeDateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (rideController){
      return Column(children: [
        InkWell(
          onTap: (){
            if(Get.find<ConfigController>().config?.scheduleTripStatus ?? false){
              Get.bottomSheet(const ScheduleDateTimePickerWidget(fromSetDestinationScreen: true),enableDrag: false, isScrollControlled: true);
            }
          },
          child: rideController.rideType == RideType.scheduleRide ?
          Container(
            padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
            ),
            child: IntrinsicHeight(
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(spacing: Dimensions.paddingSizeExtraSmall, children: [
                  Icon(Icons.calendar_today_outlined, size: 14, color: Theme.of(context).primaryColor),

                  Text(DateFormat('EEE, d MMM').format(RideControllerHelper.dateFormatToShow(rideController.scheduleTripDate)))
                ]),

                VerticalDivider(color: context.customThemeColors.blackColor.withValues(alpha: 0.1)),

                Row(spacing: Dimensions.paddingSizeExtraSmall, children: [
                  Icon(Icons.access_time, size: 14, color: Theme.of(context).hintColor.withValues(alpha: 0.9)),

                  Text(DateFormat('hh:mm a').format(RideControllerHelper.timeFormatToShow(rideController.scheduleTripTime)))
                ])
              ]),
            ),
          ) :
          Container(
            padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
            ),
            child: IntrinsicHeight(
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(spacing: Dimensions.paddingSizeSmall, children: [
                  Icon(Icons.calendar_today_outlined, size: 14, color: Theme.of(context).primaryColor),

                  Text('pickup_now'.tr)
                ]),

                Icon(Icons.access_time, size: 14)
              ]),
            ),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),

      ]);
    });
  }
}
