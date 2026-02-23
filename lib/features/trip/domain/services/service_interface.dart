abstract class TripServiceInterface{
  Future<dynamic> getTripList(String tripType, int offset, String from, String to, String filter,String status);
  Future<dynamic> getRideCancellationReasonList();
  Future<dynamic> getParcelCancellationReasonList();
}