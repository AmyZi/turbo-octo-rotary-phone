abstract class PaymentServiceInterface{
  Future<dynamic> submitReview(String id, int ratting, String comment );
  Future<dynamic> paymentSubmit(String tripId, String paymentMethod );
  Future<dynamic> getPaymentGetWayList();
  Future<bool?> saveLastPaymentMethod(String paymentMethod);
  String getLastPaymentMethod();
  Future<bool?> saveLastPaymentType(String paymentMeType);
  String getLastPaymentType();
}