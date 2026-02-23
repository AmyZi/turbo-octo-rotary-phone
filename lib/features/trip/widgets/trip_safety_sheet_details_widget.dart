import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';
import 'package:ride_sharing_user_app/features/safety_setup/widgets/after_send_alert_bottomsheet.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';

class TripSafetySheetDetailsWidget extends StatelessWidget {
  final TripDetails tripDetails;
  const TripSafetySheetDetailsWidget({super.key, required this.tripDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxHeight: Get.height * 0.8),
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius:const BorderRadius.only(
              topRight: Radius.circular(Dimensions.paddingSizeLarge),
              topLeft: Radius.circular(Dimensions.paddingSizeLarge),
            )
        ),
        child: Column(spacing: Dimensions.paddingSizeSmall,mainAxisSize: MainAxisSize.min, children: [
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () => Get.back(),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withValues(alpha:0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                child: Image.asset(Images.crossIcon,height: 10,width: 10,color: Get.isDarkMode ? Colors.white : null),
              ),
            ),
          ),

          const AfterSendAlertBottomSheet()
        ])
    );
  }
}
