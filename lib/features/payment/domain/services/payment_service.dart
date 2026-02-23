import 'package:ride_sharing_user_app/features/payment/domain/repositories/payment_repository_interface.dart';
import 'package:ride_sharing_user_app/features/payment/domain/services/payment_service_interface.dart';

class PaymentService implements PaymentServiceInterface{
  PaymentRepositoryInterface paymentRepositoryInterface;
  PaymentService({required this.paymentRepositoryInterface});

  @override
  Future paymentSubmit(String tripId, String paymentMethod) async{
   return await paymentRepositoryInterface.paymentSubmit(tripId, paymentMethod);
  }

  @override
  Future submitReview(String id, int ratting, String comment) async{
    return await paymentRepositoryInterface.submitReview(id, ratting, comment);
  }

  @override
  Future getPaymentGetWayList() async{
    return await paymentRepositoryInterface.getPaymentGetWayList();
  }

  @override
  String getLastPaymentMethod() {
    return paymentRepositoryInterface.getLastPaymentMethod();
  }

  @override
  Future<bool?> saveLastPaymentMethod(String paymentMethod) {
    return paymentRepositoryInterface.saveLastPaymentMethod(paymentMethod);
  }

  @override
  String getLastPaymentType() {
    return paymentRepositoryInterface.getLastPaymentType();
  }

  @override
  Future<bool?> saveLastPaymentType(String paymentType) {
    return paymentRepositoryInterface.saveLastPaymentType(paymentType);
  }

}