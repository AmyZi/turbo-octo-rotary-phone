import 'package:ride_sharing_user_app/features/safety_setup/domain/repositories/safety_alert_repository_interface.dart';
import 'package:ride_sharing_user_app/features/safety_setup/domain/services/safety_alert_service_interface.dart';

class SafetyAlertService implements SafetyAlertServiceInterface{
  final SafetyAlertRepositoryInterface safetyAlertRepositoryInterface;
  SafetyAlertService({required this.safetyAlertRepositoryInterface});

  @override
  Future getOthersEmergencyNumberList() async{
    return await safetyAlertRepositoryInterface.getOthersEmergencyNumberList();
  }

  @override
  Future getSafetyAlertReasonList() async{
    return await safetyAlertRepositoryInterface.getSafetyAlertReasonList();
  }

  @override
  Future getPrecautionList() async{
    return await safetyAlertRepositoryInterface.getPrecautionList();
  }

  @override
  Future storeSafetyAlert(String tripId, String comment, String lat, String lng, List<String> reasons) async{
    return await safetyAlertRepositoryInterface.storeSafetyAlert(tripId, comment, lat, lng, reasons);
  }

  @override
  Future marAsSolveSafetyAlert(String tripId, String lat, String lng) async{
    return await safetyAlertRepositoryInterface.marAsSolveSafetyAlert(tripId, lat, lng);
  }

  @override
  Future resendSafetyAlert(String tripId) async{
    return await safetyAlertRepositoryInterface.resendSafetyAlert(tripId);
  }

  @override
  Future undoSafetyAlert(String tripId) async{
    return await safetyAlertRepositoryInterface.undoSafetyAlert(tripId);
  }

  @override
  Future getSafetyAlertDetails(String tripId) async{
    return await safetyAlertRepositoryInterface.getSafetyAlertDetails(tripId);
  }

}