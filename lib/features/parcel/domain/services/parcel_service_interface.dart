abstract class ParcelServiceInterface{
  Future<dynamic> getParcelCategory();
  Future<dynamic> getSuggestedVehicleCategory(String weight);
  Future<dynamic> getRunningParcelList(int offset);
  Future<dynamic> getUnpaidParcelList(int offset);
}