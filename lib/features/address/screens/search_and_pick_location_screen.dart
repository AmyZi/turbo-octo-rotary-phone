import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing_user_app/features/address/domain/models/address_model.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/location/view/pick_map_screen.dart';
import 'package:ride_sharing_user_app/helper/route_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:get/get.dart';

class SearchAndPickLocationScreen extends StatefulWidget {
  final GoogleMapController? mapController;
  final Address? address;
  const SearchAndPickLocationScreen({super.key, this.mapController,this.address});

  @override
  State<SearchAndPickLocationScreen> createState() => _SearchAndPickLocationScreenState();
}

class _SearchAndPickLocationScreenState extends State<SearchAndPickLocationScreen> {
  TextEditingController controller = TextEditingController();
  int selectedCount = 0;

  @override
  Widget build(BuildContext context) {
      controller.text = widget.address?.address ?? Get.find<LocationController>().addAddress?.address ?? '';
      Get.find<LocationController>().searchLocation(context, widget.address?.address ?? Get.find<LocationController>().addAddress?.address ?? '', fromMap: true);

    return Scaffold(body: SafeArea(child: Container(
      color: Theme.of(context).cardColor,height: double.infinity,width: double.infinity,
      child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextField(
              cursorColor: Theme.of(context).primaryColor,
              controller: controller,
              decoration: InputDecoration(
                hintText: 'search_location'.tr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(style: BorderStyle.none, width: 0),
                ),
                hintStyle: Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
                filled: true,
                suffixIcon: const Icon(Icons.search),
                fillColor: Colors.grey.withValues(alpha:.15),
              ),
              textInputAction: TextInputAction.search,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.streetAddress,
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeLarge,
              ),
              onChanged: (String pattern) async {
                await Get.find<LocationController>().searchLocation(context, pattern, fromMap: true);
              }),

          GetBuilder<LocationController>(builder: (locationController) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: locationController.predictionList?.data?.suggestions?.length ?? 0,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: (){
                        if(selectedCount == 0){
                          selectedCount = 1;
                          Get.find<LocationController>().setLocation(
                            locationController.predictionList?.data?.suggestions?[index].placePrediction?.placeId ?? '',
                            locationController.predictionList?.data?.suggestions?[index].placePrediction?.text?.text ?? '',
                            widget.mapController, type: LocationType.location,
                          ).then((value)  {
                            locationController.locationController.text = value?.address ?? 'no';
                            Get.back();
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Row(children: [
                          const Icon(Icons.location_on),

                          const SizedBox(width: Dimensions.paddingSizeDefault,),
                          Expanded(child: Text(
                            locationController.predictionList?.data?.suggestions?[index].placePrediction?.text?.text ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                              color: Theme.of(context).textTheme.bodyLarge!.color,
                              fontSize: Dimensions.fontSizeLarge,
                            ),
                          )),
                        ]),
                      )
                  );
                }
            );
          }),

          GetBuilder<LocationController>(builder: (locationController) {
            return InkWell(
              onTap: (){
                Get.back();
                RouteHelper.goPageAndHideTextField(context, PickMapScreen(
                  type: LocationType.location,
                  onLocationPicked: (Position position, String address) {
                    locationController.mapController!.moveCamera(
                      CameraUpdate.newCameraPosition(CameraPosition(
                        target: LatLng(position.latitude, position.longitude), zoom: 16,
                      )),
                    );
                    locationController.locationController.text = address;
                  },
                  address: widget.address ?? locationController.addAddress,
                ));
              },
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Row(children: [
                  const Icon(Icons.share_location_rounded),
                  const SizedBox(width: Dimensions.paddingSizeDefault),

                  Expanded(child: Text(
                    'set_location_on_map'.tr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontSize: Dimensions.fontSizeLarge,
                    ),
                  )),
                ]),
              ),
            );
          })
        ]),
      ),
    )));
  }
}
