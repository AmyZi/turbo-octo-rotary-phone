import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ReservationNoteWidget extends StatelessWidget {
  final GlobalKey globalKey;
  const ReservationNoteWidget({super.key, required this.globalKey});

  @override
  Widget build(BuildContext context) {
    return Column(key: globalKey, children: [
      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
        ),
        padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(spacing: Dimensions.paddingSizeSmall, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('about_reservation'.tr),

          Row(spacing: Dimensions.paddingSizeSmall, children: [
            Icon(Icons.info, color: Theme.of(context).colorScheme.tertiaryContainer, size: 16),

            Expanded(child: Text(
              '${'schedule_your_ride_up_to'.tr} ${
                  (Get.find<ConfigController>().config?.advanceScheduleBookTimeType == 'day' ? (Get.find<ConfigController>().config?.advanceScheduleBookTime ?? 0) / 86400 :
                  Get.find<ConfigController>().config?.advanceScheduleBookTimeType == 'hour' ? (Get.find<ConfigController>().config?.advanceScheduleBookTime ?? 0) / 3600 :
                  (Get.find<ConfigController>().config?.advanceScheduleBookTime ?? 0) /60).toInt()
              } ${Get.find<ConfigController>().config?.advanceScheduleBookTimeType} ${'in_advance'.tr}',
              style: textRegular,
            ))
          ]),

          Row(spacing: Dimensions.paddingSizeSmall, children: [
            Icon(Icons.info, color: Theme.of(context).colorScheme.tertiaryContainer, size: 16),

            Expanded(child: Text('enjoy_free_cancellation_before_your_trip_begins'.tr, style: textRegular))
          ]),

          Row(spacing: Dimensions.paddingSizeSmall, children: [
            Icon(Icons.info, color: Theme.of(context).colorScheme.tertiaryContainer, size: 16),

            Expanded(child: Text('if_the_trip_is_cancelled_while_in_progress'.tr, style: textRegular))
          ]),
        ]),
      )
    ]);
  }
}
