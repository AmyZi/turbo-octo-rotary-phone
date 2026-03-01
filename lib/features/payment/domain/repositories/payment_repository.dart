
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/payment/domain/repositories/payment_repository_interface.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentRepository implements PaymentRepositoryInterface{
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  PaymentRepository({required this.apiClient,required this.sharedPreferences});


  @override
  Future<Response> submitReview(String id, int ratting, String comment ) async {
    return await apiClient.postData(AppConstants.submitReview,{
      "ride_request_id" : id,
      "rating" : ratting,
      "feedback" : comment
    });
  }

  @override
  Future<Response> paymentSubmit(String tripId, String paymentMethod ) async {
    return await apiClient.getData('${AppConstants.paymentUri}?trip_request_id=$tripId&payment_method=$paymentMethod');
  }

  @override
  Future getPaymentGetWayList() async{
    return await apiClient.getData(AppConstants.getPaymentMethods);
  }

  @override
  Future<bool?> saveLastPaymentMethod(String method) async {
    return await sharedPreferences.setString(AppConstants.paymentMethod, method);
  }


  @override
  String getLastPaymentMethod() {
    return sharedPreferences.getString(AppConstants.paymentMethod) ?? "";
  }

  @override
  Future<bool?> saveLastPaymentType(String type) async {
    return await sharedPreferences.setString(AppConstants.paymentType, type);
  }


  @override
  String getLastPaymentType() {
    return sharedPreferences.getString(AppConstants.paymentType) ?? "";
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