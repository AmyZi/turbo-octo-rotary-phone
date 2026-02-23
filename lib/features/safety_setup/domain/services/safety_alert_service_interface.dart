

abstract class SafetyAlertServiceInterface{

  Future<dynamic> getOthersEmergencyNumberList();
  Future<dynamic> getPrecautionList();
  Future<dynamic> getSafetyAlertReasonList();
  Future<dynamic> storeSafetyAlert(String tripId, String comment, String lat, String lng, List<String> reasons);
  Future<dynamic> marAsSolveSafetyAlert(String tripId, String lat, String lng);
  Future<dynamic> resendSafetyAlert(String tripId);
  Future<dynamic> undoSafetyAlert(String tripId);
  Future<dynamic> getSafetyAlertDetails(String tripId);
}