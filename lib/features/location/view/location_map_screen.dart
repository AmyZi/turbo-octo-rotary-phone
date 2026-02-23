import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/address/domain/models/address_model.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';

class LocationScreen extends StatefulWidget {
  final AddressModel? address;
  const LocationScreen({super.key, required this.address});

  @override
  LocationScreenState createState() => LocationScreenState();
}

class LocationScreenState extends State<LocationScreen> {
  late LatLng _latLng;
  Set<Marker> _markers = {};
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();

    _setMarker();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: BodyWidget(
          appBar: AppBarWidget(title: 'location'.tr, showActionButton: false),
          body: Center(child: GetBuilder<LocationController>(builder: (locationController) {
            return Stack(children: [

              GoogleMap(
                minMaxZoomPreference: const MinMaxZoomPreference(0, 15),
                initialCameraPosition: CameraPosition(target: locationController.initialPosition, zoom: 15),
                zoomGesturesEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                indoorViewEnabled: true,
                markers:_markers,
                onMapCreated: (controller) {
                  _mapController = controller;
                },
              ),

              Positioned(
                left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeLarge,
                child: InkWell(
                  onTap: () {
                    if(_mapController != null) {
                      _mapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: _latLng, zoom: 17)));
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                      color: Theme.of(context).cardColor,
                      boxShadow: [BoxShadow(color: Colors.grey[300]!, spreadRadius: 3, blurRadius: 10)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Icon(Icons.location_on,
                            size: 30, color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                              Text('widget.address!.addressType!', style: textRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor,
                              )),
                              const Text('widget.address!.address!', style: textMedium),
                            ]),
                          ),
                        ]),
                        // Text('- ${widget.address!.contactPersonName}', style: textMedium.copyWith(
                        //   color: Theme.of(context).primaryColor,
                        //   fontSize: Dimensions.fontSizeLarge,
                        // )),
                        //Text('- ${widget.address!.contactPersonNumber}', style: textRegular),
                      ],
                    ),
                  ),
                ),
              ),
            ]);
          })),
        ),
      ),
    );
  }

  void _setMarker() async {
    Uint8List destinationImageData = await convertAssetToUnit8List(Images.mapLocationIcon, width: 120);

    _markers = {};
    _markers.add(Marker(
      markerId: const MarkerId('marker'),
      position: Get.find<LocationController>().initialPosition,
      icon: BitmapDescriptor.bytes(destinationImageData),
    ));

    setState(() {});
  }

  Future<Uint8List> convertAssetToUnit8List(String imagePath, {int width = 50}) async {
    ByteData data = await rootBundle.load(imagePath);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!.buffer.asUint8List();
  }

}
