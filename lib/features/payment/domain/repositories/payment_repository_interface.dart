import 'package:ride_sharing_user_app/interface/repository_interface.dart';

abstract class PaymentRepositoryInterface implements RepositoryInterface{
  Future<dynamic> submitReview(String id, int ratting, String comment );
  Future<dynamic> paymentSubmit(String tripId, String paymentMethod );
  Future<dynamic> getPaymentGetWayList();
  Future<bool?> saveLastPaymentMethod(String paymentMethod);
  String getLastPaymentMethod();
  Future<bool?> saveLastPaymentType(String paymentType);
  String getLastPaymentType();
}