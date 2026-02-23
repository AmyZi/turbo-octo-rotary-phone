import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing_user_app/features/location/domain/models/prediction_model.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';


class LocationSearchDialog extends StatelessWidget {
  final GoogleMapController? mapController;
  final LocationType type;
  const LocationSearchDialog({super.key, required this.mapController, required this.type});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall),
        alignment: Alignment.topCenter,
        child: Material(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
          child: SizedBox(
            width: Get.width, child: TypeAheadField<Suggestions>(
             builder: (context,controller,focusNode){
               return TextField(
                 cursorColor: Theme.of(context).primaryColor,
                 controller: controller,
                 focusNode: focusNode,
                 textInputAction: TextInputAction.search,
                 autofocus: true,keyboardType: TextInputType.streetAddress,
                 textCapitalization: TextCapitalization.words,
                 decoration: InputDecoration(filled: true, fillColor: Theme.of(context).cardColor,
                     hintStyle: Theme.of(context).textTheme.displayMedium!.copyWith(
                         fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor),
                     hintText: 'search_location'.tr,
                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                         borderSide: const BorderSide(style: BorderStyle.none, width: 0)),
                 ),

                 style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeLarge),
               );
             },

             hideWithKeyboard: true,
             suggestionsCallback: (pattern) async {
              return await Get.find<LocationController>().searchLocation(context, pattern, fromMap: true);
            },
             itemBuilder: (context, Suggestions suggestion ) {
              return Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Row(children: [
                  const Icon(Icons.location_on),
                  Expanded(
                    child: Text(
                      suggestion.placePrediction?.text?.text ?? '',
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeLarge,
                      ),
                    ),
                  ),
                ]),
              );
            },
              onSelected: (Suggestions suggestion) {
              Get.find<LocationController>().setLocation(suggestion.placePrediction?.placeId ?? '', suggestion.placePrediction?.text?.text ?? '', mapController, type: type);
              Get.back();
            },
              emptyBuilder: (value) {
              return const SizedBox();
            },
          ),),
        ),
      ),
    );
  }
}
