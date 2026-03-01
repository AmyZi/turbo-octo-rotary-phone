import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'dart:math' as math;


class MapController extends GetxController implements GetxService {

  Set<Marker>? nearestDeliveryManMarkers;
  bool _isLoading = false;
  Map<PolylineId, Polyline> polylines = {};
  Set<Marker> markers = HashSet<Marker>();
  GoogleMapController? mapController;
  List<LatLng> _polylineCoordinateList = [];
  bool isTrafficEnable = false;

  bool get isLoading => _isLoading;

  @override
  void onInit() {
    initializeData();
    super.onInit();
  }

  void initializeData() {
    markers = {};
    polylines = {};
    _isLoading = false;
  }

  void notifyMapController() {
    update();
  }

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> getPolyline() async {
    if(Get.find<RideController>().encodedPolyLine.isNotEmpty) {
      List<LatLng> polylineCoordinates = [];
      List<LatLng> result = decodeEncodedPolyline(Get.find<RideController>().encodedPolyLine);
      if (result.isNotEmpty) {
        for (var point in result) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
        _addPolyLine(polylineCoordinates);
        _polylineCoordinateList = polylineCoordinates;

        setFromToMarker(
          LatLng(result[0].latitude, result[0].longitude),
          LatLng(result[result.length-1].latitude, result[result.length-1].longitude),
          latLongList: _polylineCoordinateList
        );
      }
    }
  }

  List<LatLng> decodeEncodedPolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      LatLng p = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }

  void _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      width: 5,
      color: Theme.of(Get.context!).primaryColor,
    );
    polylines[id] = polyline;
    update();
  }

  Future <void> searchDeliveryMen() async {
    final Uint8List carMarkerIcon = await convertAssetToUnit8List(Images.carTop, width: 25);
    final Uint8List bikeMarkerIcon = await convertAssetToUnit8List(Images.bikeTop, width: 25);
    nearestDeliveryManMarkers = {};
    for(int i = 0; i < Get.find<RideController>().nearestDriverList.length; i++) {

      MarkerId markerId = MarkerId('rider_$i');
      nearestDeliveryManMarkers!.add(Marker(
        markerId: markerId,
        visible: true,
        draggable: false,
        zIndexInt: 2,
        flat: true,
        anchor: const Offset(0.5, 0.5),
        position: LatLng(double.parse(Get.find<RideController>().nearestDriverList[i].latitude!), double.parse(Get.find<RideController>().nearestDriverList[i].longitude!)),
        icon: BitmapDescriptor.bytes(Get.find<RideController>().nearestDriverList[i].category == 'motor_bike'? bikeMarkerIcon : carMarkerIcon),
      ));

    }
    update();
  }

  double sheetHeight = 0;
  void setContainerHeight(double height , bool notify){
    sheetHeight = height;
    if(notify){
      update();
    }

  }

  void setFromToMarker(LatLng from, LatLng to,{bool isBound = true, required List<LatLng>latLongList}) async{
    markers = HashSet();
    List<LatLng> intermediateCoordinates = [];
    int markerId = 0;
    Uint8List fromMarker = await convertAssetToUnit8List(Images.fromIcon, width: 30);
    Uint8List toMarker = await convertAssetToUnit8List(Images.pickLocationIcon, width: 30);
    Uint8List intermediateIcon = await convertAssetToUnit8List(Images.ongoingMarkerIcon, width: 30);

    markers.add(Marker(
      markerId: const MarkerId('from'),
      position: from,
      anchor: const Offset(0.4, 0.7),
      infoWindow:  InfoWindow(
        title:  Get.find<RideController>().tripDetails?.pickupAddress ?? '',
        snippet: 'pick_up_location'.tr,
      ),
      icon:  BitmapDescriptor.bytes(fromMarker),
    ));

    markers.add(Marker(
      markerId: const MarkerId('to'),
      position: to,
      anchor: const Offset(0.4, 0.8),
      infoWindow:  InfoWindow(
        title:  Get.find<RideController>().tripDetails?.destinationAddress ?? '',
        snippet: 'destination'.tr,
      ),
      icon:  BitmapDescriptor.bytes(toMarker),
    ));

     if(Get.find<RideController>().currentTripDetails?.intermediateCoordinates != null){
       List<dynamic> parsedList = jsonDecode(Get.find<RideController>().currentTripDetails!.intermediateCoordinates!);

       parsedList.map((item){
         intermediateCoordinates.add(LatLng(item[0], item[1]));
       }).toList();

     }else {
       if(Get.find<LocationController>().extraOneRoute){
         intermediateCoordinates.add(LatLng(Get.find<LocationController>().extraRouteAddress?.latitude ?? 0, Get.find<LocationController>().extraRouteAddress?.longitude ?? 0));
       }
       if(Get.find<LocationController>().extraTwoRoute){
         intermediateCoordinates.add(LatLng(Get.find<LocationController>().extraRouteTwoAddress?.latitude ?? 0, Get.find<LocationController>().extraRouteTwoAddress?.longitude ?? 0));
       }

     }


    for (var coordinates in intermediateCoordinates) {
      markers.add(Marker(
        markerId: MarkerId((markerId++).toString()),
        position: coordinates,
        anchor: const Offset(0.4, 0.8),
        icon:  BitmapDescriptor.bytes(intermediateIcon),
      ));
    }


    if(isBound){
      try {
        LatLngBounds? bounds;
        if(mapController != null) {
          bounds = boundWithMaximumLatLngPoint(latLongList);
        }
        LatLng centerBounds = LatLng(
          (bounds!.northeast.latitude + bounds.southwest.latitude)/2,
          (bounds.northeast.longitude + bounds.southwest.longitude)/2,
        );
        double bearing = Geolocator.bearingBetween(from.latitude, from.longitude, to.latitude, to.longitude);
        mapController!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          bearing: bearing, target: centerBounds, zoom: 16,
        )));
        zoomToFit(mapController, bounds, centerBounds, bearing, padding: 0.5);
      }catch(e) {
        // debugPrint('jhkygutyv' + e.toString());
      }
    }

    update();
  }

  void updateMarkerAndCircle({LatLng? latLng}) async {
    markers.removeWhere((marker) => marker.markerId.value == "my_location");

    Uint8List car = await convertAssetToUnit8List( Images.mapLocationIcon, width: 100);

    if(Get.find<RideController>().tripDetails != null && _polylineCoordinateList.isNotEmpty) {
      markers.add(Marker(
        markerId: const MarkerId('my_location'),
        position: latLng ?? _polylineCoordinateList.first,
        rotation: _calculateBearing(
          _polylineCoordinateList.first,
          _polylineCoordinateList.length > 1 ?  _polylineCoordinateList[1] : _polylineCoordinateList.last,
        ),
        draggable: false,
        zIndexInt: 2,
        flat: true,
        anchor: const Offset(0.5, 0.5),
        icon: BitmapDescriptor.bytes(car),
      ));
      update();
    }
  }

  double _calculateBearing(LatLng startPoint, LatLng endPoint) {
    final double startLat = _toRadians(startPoint.latitude);
    final double startLng = _toRadians(startPoint.longitude);
    final double endLat = _toRadians(endPoint.latitude);
    final double endLng = _toRadians(endPoint.longitude);

    final double deltaLng = endLng - startLng;

    final double y = math.sin(deltaLng) * math.cos(endLat);
    final double x = math.cos(startLat) * math.sin(endLat) -
        math.sin(startLat) * math.cos(endLat) * math.cos(deltaLng);

    final double bearing = math.atan2(y, x);

    return (_toDegrees(bearing) + 360) % 360;
  }

  double _toRadians(double degrees) => degrees * (math.pi / 180.0);

  double _toDegrees(double radians) => radians * (180.0 / math.pi);

  Future<Uint8List> convertAssetToUnit8List(String imagePath, {int width = 50}) async {
    ByteData data = await rootBundle.load(imagePath);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format:ui. ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<void> zoomToFit(GoogleMapController? controller, LatLngBounds? bounds, LatLng centerBounds, double bearing, {double padding = 0.5}) async {
    bool keepZoomingOut = true;
    while(keepZoomingOut) {

      final LatLngBounds screenBounds = await controller!.getVisibleRegion();
      if(fits(bounds!, screenBounds)) {
        keepZoomingOut = false;
        final double zoomLevel = await controller.getZoomLevel() - padding;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
          bearing: bearing,
        )));
        break;
      }
      else {
        // Zooming out by 0.1 zoom level per iteration
        final double zoomLevel = await controller.getZoomLevel() - 0.1;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
      }
    }
  }

  bool fits(LatLngBounds fitBounds, LatLngBounds screenBounds) {
    final bool northEastLatitudeCheck = screenBounds.northeast.latitude >= fitBounds.northeast.latitude;
    final bool northEastLongitudeCheck = screenBounds.northeast.longitude >= fitBounds.northeast.longitude;

    final bool southWestLatitudeCheck = screenBounds.southwest.latitude <= fitBounds.southwest.latitude;
    final bool southWestLongitudeCheck = screenBounds.southwest.longitude <= fitBounds.southwest.longitude;

    return northEastLatitudeCheck && northEastLongitudeCheck && southWestLatitudeCheck && southWestLongitudeCheck;
  }

  void setOwnCurrentLocation(LatLng? latLng) async{
    markers.removeWhere((marker) => marker.markerId.value == "my_location");

    Uint8List myIcon = await convertAssetToUnit8List(Images.mapLocationIcon, width: 100);

    //LatLng? latlng = await Get.find<LocationController>().getCurrentPosition();

    if(latLng != null){
      markers.add( Marker(
          markerId: const MarkerId("my_location"),
          position: latLng,
          rotation: 192.8334901395799,
          draggable: false,
          zIndexInt: 2,
          flat: true,
          anchor: const Offset(0.5, 0.5),
          icon: BitmapDescriptor.bytes(myIcon)));

      if(mapController != null){
        mapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            bearing: 192.8334901395799,
            target: latLng,
            tilt: 0,
            zoom: 16
        )));
      }
    }
    update();
  }


  Future<void> getDriverToPickupOrDestinationPolyline(String lines,{bool mapBound = false}) async {
    if(lines.isNotEmpty) {
      List<LatLng> polylineCoordinates = [];
      List<LatLng> result = decodeEncodedPolyline(lines);
      if (result.isNotEmpty) {
        for (var point in result) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
        isInsideCircle(result[0].latitude, result[0].longitude, result[result.length-1].latitude, result[result.length-1].longitude, Get.find<ConfigController>().config!.completionRadius!);
        _addPolyLine(polylineCoordinates);
        _polylineCoordinateList = polylineCoordinates;
        updateDriverMarker(_polylineCoordinateList);


        if(mapBound){
          boundMapScreen(LatLng(result[0].latitude, result[0].longitude), LatLng(result[result.length-1].latitude, result[result.length-1].longitude));
        }
      }
    }
  }

  void updateDriverMarker(List<LatLng> latLngList) async{
    markers.removeWhere((marker) => marker.markerId.value == "driverPosition");

    Uint8List car = await convertAssetToUnit8List(Get.find<RideController>().tripDetails!.vehicleCategory!.type == 'car'? Images.carTop : Images.bike, width: 25);


    if(Get.find<RideController>().tripDetails != null && latLngList.isNotEmpty) {
      markers.add(Marker(
        markerId: const MarkerId('driverPosition'),
        position: latLngList.first,
        rotation: _calculateBearing(
          latLngList.first,
          latLngList.length > 1 ?  latLngList[1] : latLngList.last,
        ),
        draggable: false,
        zIndexInt: 2,
        flat: true,
        anchor: const Offset(0.5, 0.5),
        icon: BitmapDescriptor.bytes(car),
      ));
      update();
    }

  }

  bool _isInside = false;
  bool get isInside => _isInside;

  double distanceBetween(double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
    double distance = Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);
    return distance; // Distance in meters
  }

  void isInsideCircle(double lat, double lng, double latCenter, double lngCenter, double radius) {
    // Calculate the distance between two points using Haversine formula
    double distance = distanceBetween(lat, lng, latCenter, lngCenter);
    // Check if the distance is less than or equal to the radius
    _isInside = (distance <= radius) ? true : false;
  }


  void setMarkersInitialPosition(){
    if(Get.find<RideController>().encodedPolyLine.isNotEmpty) {
      List<LatLng> markers = decodeEncodedPolyline(Get.find<RideController>().encodedPolyLine);
      setFromToMarker(
          LatLng(markers[0].latitude, markers[0].longitude),
          LatLng(markers[markers.length-1].latitude, markers[markers.length-1].longitude),
          isBound: false,latLongList: markers
      );
    }
  }

  void boundMapScreen(LatLng startingPoint , LatLng endingPoint){
    try {
      LatLngBounds? bounds;
      if(mapController != null) {
        if (startingPoint.latitude < endingPoint.latitude) {
          bounds = LatLngBounds(southwest: startingPoint, northeast: endingPoint);
        }else {
          bounds = LatLngBounds(southwest: endingPoint, northeast: startingPoint);
        }
      }
      LatLng centerBounds = LatLng(
        (bounds!.northeast.latitude + bounds.southwest.latitude)/2,
        (bounds.northeast.longitude + bounds.southwest.longitude)/2,
      );
      double bearing = Geolocator.bearingBetween(startingPoint.latitude, startingPoint.longitude, endingPoint.latitude, endingPoint.longitude);
      mapController!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: bearing, target: centerBounds, zoom: 16,
      )));
      zoomToFit(mapController, bounds, centerBounds, bearing, padding: 0.5);
    }catch(e) {
      // debugPrint('jhkygutyv' + e.toString());
    }
  }


  LatLngBounds boundWithMaximumLatLngPoint(List<LatLng> list) {
    assert(list.isNotEmpty);
    var firstLatLng = list.first;
    var s = firstLatLng.latitude,
        n = firstLatLng.latitude,
        w = firstLatLng.longitude,
        e = firstLatLng.longitude;
    for (var i = 1; i < list.length; i++) {
      var latlng = list[i];
      s = min(s, latlng.latitude);
      n = max(n, latlng.latitude);
      w = min(w, latlng.longitude);
      e = max(e, latlng.longitude);
    }
    return LatLngBounds(southwest: LatLng(s, w), northeast: LatLng(n, e));
  }

  void toggleTrafficView(){
    isTrafficEnable = !isTrafficEnable;
    update();
  }

}