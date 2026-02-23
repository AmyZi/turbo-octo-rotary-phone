import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/bidding_model.dart';
import 'package:ride_sharing_user_app/features/ride/widgets/bidding_list_screen.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';

class RiderDetailsWidget extends StatefulWidget {
  final bool fromNotification;
  final Bidding bidding;
  final String tripId;
  const RiderDetailsWidget({super.key,this.fromNotification = true, required this.bidding, required this.tripId});

  @override
  State<RiderDetailsWidget> createState() => _RiderDetailsWidgetState();
}

class _RiderDetailsWidgetState extends State<RiderDetailsWidget> {


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=> Get.off(()=> BiddingListScreen(tripId: widget.tripId, fromList: true)),
      child: GetBuilder<RideController>(builder: (rideController) {
        return Padding(
          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
          child: Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: Get.isDarkMode? Theme.of(context).canvasColor :Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
            ),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.radiusOverLarge),
                    bottomLeft: Radius.circular(Dimensions.radiusOverLarge),
                    bottomRight: Radius.circular(Dimensions.radiusSmall),
                    topRight: Radius.circular(Dimensions.radiusSmall),
                  ),
                  child: ImageWidget(height: 50, width: 50,
                    image: '${Get.find<ConfigController>().config!.imageBaseUrl!.profileImageDriver}/${widget.bidding.driver!.profileImage}',
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text.rich(TextSpan(
                    style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge,
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha:0.8)),
                    children:  [
                      TextSpan(text: '${widget.bidding.driver?.firstName} ${widget.bidding.driver?.lastName}',
                        style: textMedium.copyWith(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: Dimensions.fontSizeDefault,
                        ),
                      ),
                    ],
                  )),

                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text.rich(TextSpan(
                      style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge,
                          color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8)),
                      children:  [
                        TextSpan(text: widget.bidding.driver?.vehicle?.model?.name??'',
                          style: textMedium.copyWith(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: Dimensions.fontSizeDefault,
                          ),
                        ),

                        const TextSpan(text: " "),

                        WidgetSpan(
                          child: Icon(Icons.star,color: Theme.of(context).colorScheme.primaryContainer,size: 15),
                          alignment: PlaceholderAlignment.middle,
                        ),
                        TextSpan(
                          text:widget.bidding.driverAvgRating != null ?
                          double.parse(widget.bidding.driverAvgRating.toString()).toStringAsFixed(1) :
                          '0',
                          style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                        )
                      ],
                    )),


                    Text(PriceConverter.convertPrice(widget.bidding.bidFare!),
                      style: textRobotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha:0.8),
                      ),
                    ),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(
                      "distance_from_you".tr,
                      style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault,
                          color: Theme.of(context).primaryColorDark.withValues(alpha:0.6)),
                      overflow: TextOverflow.ellipsis,
                    ),

                    if(rideController.remainingDistanceModel.isNotEmpty)
                      Text(
                        "${rideController.remainingDistanceModel[0].distanceText}",
                        style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault,
                            color: Theme.of(context).primaryColorDark.withValues(alpha:0.6)),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ]),
                ]))
              ]),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              Row(children: [
                Expanded(child: ButtonWidget(
                  buttonText: 'decline'.tr,
                  borderWidth: 0.1,
                  radius: Dimensions.radiusLarge,
                  fontSize: Dimensions.fontSizeDefault,
                  borderColor: Theme.of(Get.context!).colorScheme.error,
                  textColor: Theme.of(context).colorScheme.error.withValues(alpha:0.9),
                  backgroundColor: Theme.of(context).hintColor.withValues(alpha:.25),
                  boldText: false,
                  onPressed: (){
                    rideController.ignoreBidding(widget.bidding.id!,widget.tripId);
                  },
                )),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                Expanded(child: ButtonWidget(
                  radius: Dimensions.radiusLarge,
                  buttonText: 'accept'.tr,
                  fontSize: Dimensions.fontSizeDefault,
                  onPressed: () async{
                    rideController.tripAcceptOrRejected(widget.bidding.tripRequestsId!, 'accepted', widget.bidding.driver!.id!);
                  },
                )),
              ])
            ]),
          ),
        );
      }),
    );
  }
}
