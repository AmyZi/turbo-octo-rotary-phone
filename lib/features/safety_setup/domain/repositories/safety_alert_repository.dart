import 'dart:convert';

import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/safety_setup/domain/repositories/safety_alert_repository_interface.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class SafetyAlertRepository implements SafetyAlertRepositoryInterface{
  final ApiClient apiClient;
  SafetyAlertRepository({required this.apiClient});

  @override
  Future<Response> getOthersEmergencyNumberList() async {
    return await apiClient.getData(AppConstants.getOtherEmergencyNumberList);
  }

  @override
  Future<Response> getSafetyAlertReasonList() async {
    return await apiClient.getData(AppConstants.getSafetyAlertReasonList);
  }

  @override
  Future<Response> getPrecautionList() async {
    return await apiClient.getData(AppConstants.getPrecautionList);
  }

  @override
  Future storeSafetyAlert(String tripId, String comment, String lat, String lng, List<String> reasons) async{
    return await apiClient.postData(
        AppConstants.storeSafetyAlert,
        {
          "trip_request_id" : tripId,
          "lat" : lat,
          "lng" : lng,
          "comment" : comment,
          "reason" : jsonEncode(reasons),
        }
    );
  }

  @override
  Future marAsSolveSafetyAlert(String tripId, String lat, String lng) async{
    return await apiClient.postData(
        '${AppConstants.markAsSolvedSafetyAlert}$tripId',
        {
          "_method": "put",
          "lat" : lat,
          "lng" : lng,
        }
    );
  }

  @override
  Future resendSafetyAlert(String tripId) async{
    return await apiClient.postData(
        '${AppConstants.resendSafetyAlert}$tripId',
        {
          "_method": "put"
        }
    );
  }

  @override
  Future undoSafetyAlert(String tripId) async{
    return await apiClient.postData(
        '${AppConstants.undoSafetyAlert}$tripId',
        {
          "_method": "delete"
        }
    );
  }

  @override
  Future getSafetyAlertDetails(String tripId) async{
    return await apiClient.getData('${AppConstants.customerAlertDetails}$tripId');
  }
}