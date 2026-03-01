import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/rider_details.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/trip_route_widget.dart';
import 'package:ride_sharing_user_app/theme/theme_controller.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ScheduleTripMapView extends StatelessWidget {
  final TripDetails tripDetails;
  const ScheduleTripMapView({super.key,  required this.tripDetails});

  @override
  Widget build(BuildContext context) {
    String firstRoute = '';
    String secondRoute = '';
    List<dynamic> extraRoute = [];
    if(tripDetails.intermediateAddresses != null && tripDetails.intermediateAddresses != '[[, ]]'){
      extraRoute = jsonDecode(tripDetails.intermediateAddresses!);
      if(extraRoute.isNotEmpty){
        firstRoute = extraRoute[0];
      }
      if(extraRoute.isNotEmpty && extraRoute.length > 1){
        secondRoute = extraRoute[1];
      }
    }

    return SafeArea(
      top: false,
      child: Scaffold(
        body: BodyWidget(
          appBar: AppBarWidget(
            title: '${'trip'.tr} #${tripDetails.refId}',
            centerTitle: true,
            onBackPressed: ()=> Get.back(),
          ),
          body: GetBuilder<MapController>(builder: (rideMapController){
            return ExpandableBottomSheet(
                persistentContentHeight: 200,
                background:  Padding(
                  padding:  EdgeInsets.only(bottom: 150),
                  child: GoogleMap(
                    style: Get.isDarkMode ?
                    Get.find<ThemeController>().darkMap : Get.find<ThemeController>().lightMap,
                    initialCameraPosition:  CameraPosition(
                      target: Get.find<LocationController>().initialPosition,
                      zoom: 16,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      rideMapController.mapController = controller;
                      rideMapController.getPolyline();
                    },
                    minMaxZoomPreference: const MinMaxZoomPreference(0, AppConstants.mapZoom),
                    markers: Set<Marker>.of(rideMapController.markers),
                    polylines: Set<Polyline>.of(rideMapController.polylines.values),
                    zoomControlsEnabled: false,
                    compassEnabled: false,
                    // trafficEnabled: mapController.isTrafficEnable,
                    indoorViewEnabled: true,
                    mapToolbarEnabled: true,
                  ),
                ),
                expandableContent: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius : const BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.paddingSizeDefault),
                      topRight : Radius.circular(Dimensions.paddingSizeDefault),
                    ),
                    boxShadow: [BoxShadow(
                      color: Theme.of(context).hintColor,
                      blurRadius: 5, spreadRadius: 1, offset: const Offset(0,2),
                    )],
                  ),
                  child: Padding(
                      padding:  const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child : Column(mainAxisSize: MainAxisSize.min, children: [
                        Container(height: 7, width: 30, decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                        )),

                        Align(alignment: Alignment.centerLeft, child: Text('trip_info'.tr, style: textSemiBold)),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                              border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2))
                          ),
                          padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: TripRouteWidget(
                            pickupAddress: tripDetails.pickupAddress ?? '',
                            destinationAddress: tripDetails.destinationAddress ?? '',
                            extraOne: firstRoute,extraTwo: secondRoute,entrance: tripDetails.entrance,
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        (tripDetails.currentStatus == AppConstants.pending) ?
                        Text('once_a_driver_accept_your_request'.tr) :
                        ActivityScreenRiderDetails(),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                      ])
                  ),
                )
            );
          }),
        ),
      ),
    );
  }
}
