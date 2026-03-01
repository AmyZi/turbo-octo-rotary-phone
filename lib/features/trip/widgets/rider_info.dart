import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';

class RiderInfo extends StatelessWidget {
  final TripDetails tripDetails;
  const RiderInfo({super.key, required this.tripDetails});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
          child: Text('rider_details'.tr, style: textSemiBold.copyWith(
              fontSize: Dimensions.fontSizeDefault,color: Theme.of(context).textTheme.bodyMedium?.color,
          )),
        ),

        Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              border: Border.all(color: Theme.of(context).colorScheme.secondaryFixedDim.withValues(alpha:0.11))
            ),
            child: Row(children: [
              Expanded(flex: 4, child: Row(children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    child: ImageWidget(height: 40, width: 40,
                      image: tripDetails.driver != null ? '${Get.find<ConfigController>().config!.imageBaseUrl!.profileImageDriver}'
                          '/${tripDetails.driver!.profileImage}' : '',
                    )),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  tripDetails.driver != null ?
                  Text('${tripDetails.driver!.firstName!} ${tripDetails.driver!.lastName!}',
                    style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                    overflow: TextOverflow.ellipsis,
                  ) :
                  const SizedBox(),

                  Text.rich(TextSpan(
                    style: textRegular.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8),
                    ),
                    children:  [
                      WidgetSpan(
                        child: Icon(
                          Icons.star,color: Theme.of(context).colorScheme.primaryContainer,size: 15,
                        ), alignment: PlaceholderAlignment.middle,
                      ),
                      TextSpan(
                          text: double.parse(tripDetails.driverAvgRating != null ?tripDetails.driverAvgRating.toString(): '0').toStringAsFixed(1),
                          style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyMedium?.color),
                      ),
                    ],
                  )),
                ]))
              ])),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                color: Theme.of(context).colorScheme.secondaryFixedDim.withValues(alpha:0.5),
                width: 1,height: 40,
              ),

              tripDetails.vehicle != null ?
              Flexible(flex: 3, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(tripDetails.vehicle!.licencePlateNumber ?? '',
                  style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                  overflow: TextOverflow.ellipsis,
                ),

                Row(children: [
                  Flexible(child: Text(
                    tripDetails.vehicle?.model?.name ??  '',
                    style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault,color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.7)),
                    overflow: TextOverflow.ellipsis,
                  )),

                  Container(
                    margin: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall,vertical: Dimensions.paddingSizeThree),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha:0.1),
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
                    ),
                    child: Text(tripDetails.vehicleCategory?.name ??  ''),
                  )
                ]),
              ])) :
              const SizedBox(),

            ]),
          ),
      ]);
  }
}
