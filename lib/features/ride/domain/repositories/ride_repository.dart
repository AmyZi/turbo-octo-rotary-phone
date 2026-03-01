import 'dart:convert';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';
import 'package:ride_sharing_user_app/features/ride/domain/repositories/ride_repository_interface.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class RideRepository implements RideRepositoryInterface{
  final ApiClient apiClient;
  RideRepository({required this.apiClient});


  @override
  Future<Response?> getEstimatedFare({
    required LatLng pickupLatLng,
    required LatLng destinationLatLng,
    required LatLng currentLatLng,
    required String type,
    required String pickupAddress,
    required String destinationAddress,
    LatLng? extraOneLatLng = const LatLng(0, 0),
    LatLng? extraTwoLatLng = const LatLng(0, 0),
    bool extraOne = false, bool extraTwo = false,
    String? parcelWeight,
    String? parcelCategoryId,
    String? rideRequestType,
    required String? scheduledAt,
  }) async {
    return await apiClient.postData(AppConstants.estimatedFare, {
      "pickup_coordinates" : '[${pickupLatLng.latitude},${pickupLatLng.longitude}]',
      "destination_coordinates" : '[${destinationLatLng.latitude},${destinationLatLng.longitude}]',
      "type" : type,
      "ride_request_type" : rideRequestType,
      "pickup_address": pickupAddress,
      "destination_address": destinationAddress,
      "intermediate_coordinates": (extraOne && !extraTwo) ? '[[${extraOneLatLng?.latitude},${extraOneLatLng?.longitude}]]': (extraOne && extraTwo)
          ? '[[${extraOneLatLng?.latitude},${extraOneLatLng?.longitude}],[${extraTwoLatLng?.latitude}, ${extraTwoLatLng?.longitude}]]' : '',
      'parcel_weight' : type == 'parcel' ?  Get.find<ParcelController>().parcelWeightController.text : parcelWeight,
      "parcel_category_id" :type == 'parcel' ? Get.find<ParcelController>().parcelCategoryList![Get.find<ParcelController>().selectedParcelCategory].id : parcelCategoryId,
      "scheduled_at" : scheduledAt,
    });
  }

  @override
  Future<Response> submitRideRequest(
      {required String pickupLat,
        required String pickupLng,
        required String destinationLat,
        required String destinationLng,
        required String customerCurrentLat,
        required String customerCurrentLng,
        required String vehicleCategoryId,
        required String estimatedDistance,
        required String estimatedTime,
        required String estimatedFare,
        required String actualFare,
        required String note,
        required String paymentMethod,
        required String type,
        required bool bid,
        required String pickupAddress,
        required String destinationAddress,
        required String encodedPolyline,
        required List<String> middleAddress,
        required String entrance,
        required double? extraEstimatedFare,
        required double? extraDiscountFare,
        required double? extraDiscountAmount,
        required double? extraReturnFee,
        required double? extraCancellationFee,
        required double? extraFareAmount,
        required double? extraFareFee,
        required String? zoneId,

        String? areaId,
        String extraLatOne = '',
        String extraLngOne = '',
        String extraLatTwo = '',
        String extraLngTwo = '',
        bool extraOne = false,
        bool extraTwo = false,
        String? senderName,
        String? senderPhone,
        String? senderAddress,
        String? receiverName,
        String? receiverPhone,
        String? receiverAddress,
        String? parcelCategoryId,
        String? weight,
        String? payer,
        String? tripRequestId,
        double? returnFee,
        double? cancellationFee,
        required String? scheduledAt,
        String? rideRequestType,
        double? surgeMultiplier,
      }) async {
    return await apiClient.postData(AppConstants.rideRequest, {
      "pickup_coordinates" : '[$pickupLat,$pickupLng]',
      "destination_coordinates" : '[$destinationLat,$destinationLng]',
      "customer_coordinates": '[$customerCurrentLat,$customerCurrentLng]',
      "customer_request_coordinates": '[$customerCurrentLat,$customerCurrentLng]',
      "vehicle_category_id" : vehicleCategoryId,
      "estimated_distance": estimatedDistance.replaceAll('km', ''),
      "estimated_time": estimatedTime.replaceAll('min', ''),
      "estimated_fare": estimatedFare,
      "actual_fare": actualFare,
      "note" : note,
      "payment_method" : paymentMethod,
      "type" : type,
      "bid" : bid,
      "pickup_address": pickupAddress,
      "destination_address": destinationAddress,
      "intermediate_addresses" : jsonEncode(middleAddress),
      "entrance": entrance,
      "intermediate_coordinates": (extraOne && !extraTwo)?'[[$extraLatOne,$extraLngOne]]':(extraOne && extraTwo)?'[[$extraLatOne,$extraLngOne],[$extraLatTwo, $extraLngTwo]]': null,
      "area_id" : areaId,
      "sender_name" :type == 'parcel' ? Get.find<ParcelController>().senderNameController.text : senderName,
      "sender_phone" :type == 'parcel' ? Get.find<ParcelController>().getSenderContactNumber : senderPhone,
      "sender_address":type == 'parcel' ? Get.find<ParcelController>().senderAddressController.text : senderAddress,
      "receiver_name":type == 'parcel' ? Get.find<ParcelController>().receiverNameController.text : receiverName,
      "receiver_phone":type == 'parcel' ? Get.find<ParcelController>().getReceiverContactNumber : receiverPhone,
      "receiver_address" :type == 'parcel' ? Get.find<ParcelController>().receiverAddressController.text : receiverAddress,
      "parcel_category_id" :type == 'parcel' ? Get.find<ParcelController>().parcelCategoryList![Get.find<ParcelController>().selectedParcelCategory].id : parcelCategoryId,
      "weight" :type == 'parcel' ? Get.find<ParcelController>().parcelWeightController.text : weight,
      "payer" :type == 'parcel' ? Get.find<ParcelController>().payReceiver?'receiver':"sender" : payer,
      "encoded_polyline" : encodedPolyline,
      "trip_request_id" : tripRequestId,
      "return_fee": returnFee,
      "cancellation_fee": cancellationFee,
      'extra_estimated_fare' : extraEstimatedFare,
      'extra_discount_fare' : extraDiscountFare,
      'extra_discount_amount' : extraDiscountAmount,
      'extra_return_fee' : extraReturnFee,
      'extra_cancellation_fee' : extraCancellationFee,
      'extra_fare_amount' : extraFareAmount,
      'extra_fare_fee' : extraFareFee,
      'zone_id' : zoneId,
      "scheduled_at" : scheduledAt,
      "ride_request_type" : rideRequestType,
      "surge_multiplier" : surgeMultiplier

    });
  }

  @override
  Future<Response> getRideDetails(String tripId) async {
    return await apiClient.getData('${AppConstants.tripDetails}$tripId');
  }

  @override
  Future<Response> tripStatusUpdate(String id, String status,String cancellationCause) async {
    return await apiClient.postData('${AppConstants.updateTripStatus}$id',
        {
          "status": status,
          "cancel_reason": cancellationCause,
          "_method" : 'put'
        });
  }

  @override
  Future<Response> remainDistance(String requestID) async {
    return await apiClient.postData(AppConstants.remainDistance, {"trip_request_id": requestID});
  }

  @override
  Future<Response> biddingList(String tripId, int offset) async {
    return await apiClient.getData('${AppConstants.biddingList}$tripId?limit=10&offset=$offset');
  }

  @override
  Future<Response> nearestDriverList(String  lat, String lng) async {
    return await apiClient.getData('${AppConstants.nearestDriverList}?latitude=$lat&longitude=$lng');
  }

  @override
  Future<Response> tripAcceptOrReject(String tripId, String type, String driverId) async {
    return await apiClient.postData(AppConstants.tripAcceptOrReject,{
      "trip_request_id": tripId,
      "action" : type,
      "driver_id" : driverId
    });
  }

  @override
  Future<Response> ignoreBidding(String biddingId) async {
    return await apiClient.postData(AppConstants.ignoreBidding, {
      "_method" : 'put',
      "bidding_id" : biddingId
    });
  }

  @override
  Future<Response> getCurrentRegularRide() async {
    return await apiClient.getData(AppConstants.currentRideStatus);
  }

  @override
  Future<Response> getFinalFare(String id) async {
    return await apiClient.getData('${AppConstants.finalFare}?trip_request_id=$id');
  }


  @override
  Future<Response> getDriverLocation(String tripId) async {
    return await apiClient.getData('${AppConstants.arrivalPickupPoint}=$tripId');
  }

  @override
  Future<Response> getRunningRideList() async {
    return await apiClient.getData(AppConstants.getRunningRideList);
  }

  @override
  Future<Response?> getDirection({required LatLng pickupLatLng, required LatLng destinationLatLng, required LatLng extraOneLatLng, required LatLng extraTwoLatLng}) async {
    return await apiClient.getData('/api/get-direction?origin=${pickupLatLng.latitude}'
        ',${pickupLatLng.longitude}&destination=${destinationLatLng.latitude},${destinationLatLng.longitude}'
        '&waypoints=${extraOneLatLng.latitude},${extraOneLatLng.longitude}|${extraTwoLatLng.latitude},${extraTwoLatLng.longitude}');
  }

  @override
  Future<Response> parcelReceived(String tripId) async {
    return await apiClient.postData(AppConstants.parcelReceived+tripId,
        {
          "_method" : "put"
        });
  }

  @override
  Future updateScheduleTripTimeDate(String? tripId, String? scheduledAt) async{
    return await apiClient.putData('${AppConstants.updateScheduleTrip}$tripId', {
      "scheduled_at" : scheduledAt
    });

  }


  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset = 1}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(value, {int? id}) {
    // TODO: implement update
    throw UnimplementedError();
  }

}