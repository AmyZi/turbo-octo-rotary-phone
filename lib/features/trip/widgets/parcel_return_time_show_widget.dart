import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ParcelReturnTimeShowWidget extends StatelessWidget {
  final TripDetails? tripDetails;
  const ParcelReturnTimeShowWidget({super.key, this.tripDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeThree,horizontal: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeThree),
            color: Theme.of(context).hintColor.withValues(alpha: 0.1)
        ),
        child: Text.rich(textAlign: TextAlign.center, TextSpan(
          style: textRegular.copyWith(
            fontSize: Dimensions.fontSizeLarge,
            color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8),
          ),
          children:  [
            TextSpan(text: 'estimated_return_time'.tr, style: textRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7)
            )),

            TextSpan(text: ':', style: textRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7)
            )),

            TextSpan(
              text: ' ${DateConverter.stringToLocalDateTime(tripDetails!.returnTime!)}',
              style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7)),
            ),
          ],
        ))
    );
  }
}
