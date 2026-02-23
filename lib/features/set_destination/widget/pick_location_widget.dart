import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/custom_search_field.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';

class PickLocationWidget extends StatelessWidget {
  final TripDetails? rideDetails;
  final FocusNode? focusNode;
  final TextEditingController textEditingController;
  final LocationType locationType;
  final VoidCallback locationIconTap;
  final VoidCallback? textFieldTap;
  final bool isShowCrossButton;
  final String textFieldHint;

  const PickLocationWidget({
    super.key, this.rideDetails,
    this.focusNode,
    required this.textEditingController,
    required this.locationType,
    required this.locationIconTap,
    required this.isShowCrossButton,
    required this.textFieldHint,
    this.textFieldTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      ),
      child: Row(children: [
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

        Expanded(child: CustomSearchField(
            focusNode: focusNode,
            controller: textEditingController,
            hint: textFieldHint,
            onTap: textFieldTap,
            onChanged: (value) async {
              return await Get.find<LocationController>().searchLocation(
                context, value, type: locationType,
              );
            },
        )),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        InkWell(
          onTap: locationIconTap,
          child: Icon(Icons.place_outlined, color: Theme.of(context).primaryColor),
        ),

        if(isShowCrossButton)
        InkWell(
          onTap: ()=> Get.find<LocationController>().setExtraRoute(remove: true),
          child: Icon(Icons.clear, color: Theme.of(context).primaryColor),
        ),

      ]),
    );
  }
}
