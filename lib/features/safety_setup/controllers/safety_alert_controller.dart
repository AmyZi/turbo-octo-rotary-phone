import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/safety_setup/domain/models/customer_alert_details.dart';
import 'package:ride_sharing_user_app/features/safety_setup/domain/models/other_emergency_number_model.dart';
import 'package:ride_sharing_user_app/features/safety_setup/domain/models/precaution_list_model.dart';
import 'package:ride_sharing_user_app/features/safety_setup/domain/models/safety_alert_reason_model.dart';
import 'package:ride_sharing_user_app/features/safety_setup/domain/services/safety_alert_service_interface.dart';
import 'package:ride_sharing_user_app/features/safety_setup/widgets/safety_alert_delay_widget.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';

 enum SafetyAlertState{initialState,predefineAlert,afterSendAlert,otherNumberState}

class SafetyAlertController extends GetxController implements GetxService {
  final SafetyAlertServiceInterface safetyAlertServiceInterface;
  SafetyAlertController({required this.safetyAlertServiceInterface});

  SafetyAlertState currentState = SafetyAlertState.initialState;
  bool isLoading = false;
  bool isStoring = false;
  SafetyAlertReasonModel? safetyAlertReasonModel;
  OtherEmergencyNumberModel? otherEmergencyNumberModel;
  CustomerAlertDetails? customerAlertDetails;
  PrecautionListModel? precautionListModel;

  void updateSafetyAlertState(SafetyAlertState state,{bool isUpdate = true}){
    currentState = state;

    if(isUpdate){
      update();
    }
  }

  void selectSafetyReason(int index){
    safetyAlertReasonModel!.data![index].isActive = !safetyAlertReasonModel!.data![index].isActive!;
    update();
  }


  void getOthersEmergencyNumberList({bool isUpdate = false}) async{
    isLoading = true;

    if(isUpdate) {
      update();
    }
    Response response = await safetyAlertServiceInterface.getOthersEmergencyNumberList();

    if (response.statusCode == 200) {
      otherEmergencyNumberModel = OtherEmergencyNumberModel.fromJson(response.body);
      isLoading = false;

    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }

    update();

  }

  void getSafetyAlertReasonList({bool isUpdate = false}) async{
    isLoading = true;

    if(isUpdate) {
      update();
    }
    Response response = await safetyAlertServiceInterface.getSafetyAlertReasonList();

    if (response.statusCode == 200) {
      safetyAlertReasonModel = SafetyAlertReasonModel.fromJson(response.body);
      isLoading = false;

    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();

  }

  List<String> reasons = [];
  Future<bool> storeSafetyAlert(String comments) async{
    reasons = [];
    isStoring = true;
    update();

    for(int i =0 ; i< (safetyAlertReasonModel?.data?.length ?? 0) ; i++){
      if(safetyAlertReasonModel?.data?[i].isActive ?? false){
        reasons.add(safetyAlertReasonModel?.data?[i].reason ?? '');
      }
    }

    LatLng? latLng = await Get.find<LocationController>().getCurrentPosition();

    Response response = await safetyAlertServiceInterface.storeSafetyAlert(
        Get.find<RideController>().currentTripDetails?.id ?? Get.find<RideController>().rideDetails?.id ?? '',
        comments,
        (latLng?.latitude ?? '').toString(),
        (latLng?.longitude ?? '').toString(),
        reasons
    );

    if(response.statusCode == 200){
      isStoring = false;
      cancelDriverNeedSafetyStream();
      return true;
    }else{
      isStoring = false;
      update();
      ApiChecker.checkApi(response);
      return false;
    }
  }

  void resendSafetyAlert() async{
    isStoring = true;
    update();

    Response response = await safetyAlertServiceInterface.resendSafetyAlert(
        Get.find<RideController>().currentTripDetails?.id ?? Get.find<RideController>().rideDetails?.id ?? ''
    );

    if(response.statusCode == 200){
      isStoring = false;
      showCustomSnackBar(response.body['message'],isError: false);
    }else{
      isStoring = false;
      ApiChecker.checkApi(response);
    }

    update();
  }

  void marAsSolveSafetyAlert() async{
    isLoading = true;
    update();
    LatLng? latLng = await Get.find<LocationController>().getCurrentPosition();

    Response response = await safetyAlertServiceInterface.marAsSolveSafetyAlert(
        Get.find<RideController>().currentTripDetails?.id ?? Get.find<RideController>().rideDetails?.id ?? '',
        (latLng?.latitude ?? '').toString(),
        (latLng?.longitude ?? '').toString()
    );

    if(response.statusCode == 200){
      isLoading = false;
      Get.back();
      showCustomSnackBar(response.body['message'],isError: false);
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
  }

  void undoSafetyAlert() async{
    isLoading = true;
    update();

    Response response = await safetyAlertServiceInterface.undoSafetyAlert(Get.find<RideController>().currentTripDetails?.id ?? Get.find<RideController>().rideDetails?.id ?? '');

    if(response.statusCode == 200){
      showCustomSnackBar(response.body['message'],isError: false);
      currentState = SafetyAlertState.initialState;
      isLoading = false;
      checkDriverNeedSafety();
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
  }

  void getSafetyAlertDetails(String tripId) async{
    Response response = await safetyAlertServiceInterface.getSafetyAlertDetails(tripId);

    if (response.statusCode == 200) {
      customerAlertDetails = CustomerAlertDetails.fromJson(response.body);
      update();
    }else{
      ApiChecker.checkApi(response);
    }
  }

  void getPrecautionList({bool isUpdate = false}) async{
    isLoading = true;

    if(isUpdate) {
      update();
    }
    Response response = await safetyAlertServiceInterface.getPrecautionList();

    if (response.statusCode == 200) {
      precautionListModel = PrecautionListModel.fromJson(response.body);
      isLoading = false;

    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();

  }

  Timer? _timer;
  Position? oldPosition, newLocation;

  void checkDriverNeedSafety() async{

    oldPosition = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.low)
    );

    _timer?.cancel();

    _timer = Timer.periodic(Duration(seconds: Get.find<ConfigController>().config?.safetyFeatureMinimumTripDelayTime ?? 60), (_) async{
      newLocation = await Geolocator.getCurrentPosition(
          locationSettings: LocationSettings(accuracy: LocationAccuracy.low)
      );

      double distance = Geolocator.distanceBetween(oldPosition?.latitude ?? 0, oldPosition?.longitude ?? 0, newLocation?.latitude ?? 0, newLocation?.longitude ?? 0);

      if(distance > 20){
        oldPosition = newLocation;
      }else {
        if(!(Get.isBottomSheetOpen ?? false) && !((Get.find<RideController>().remainingDistanceModel[0].durationSec ?? 0) < (Get.find<RideController>().remainingDistanceModel[0].durationInTrafficSec ?? 0))){
          Get.bottomSheet(
            isScrollControlled: true,
            const SafetyAlertDelayWidget(),
            backgroundColor: Theme.of(Get.context!).cardColor,isDismissible: false,
          );
        }
      }
    });

  }

  void cancelDriverNeedSafetyStream(){
    currentState = SafetyAlertState.initialState;
    _timer?.cancel();
    oldPosition = newLocation = null;
  }


}