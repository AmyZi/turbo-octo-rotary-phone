
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/refund_request/domain/repositories/refund_request_repository_interface.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class RefundRequestRepository implements RefundRequestRepositoryInterface{
  final ApiClient apiClient;
  RefundRequestRepository({required this.apiClient});

  @override
  Future getParcelRefundReasonList() async{
    return await apiClient.getData(AppConstants.getParcelRefundReasonList);
  }

  @override
  Future sendRefundRequest({
    required String tripId,
    required String refundReason,
    String? refundNote,
    required double productApproximatePrice,
    required List<MultipartBody> proofImage,
  }) async{
    return await apiClient.postMultipartData(
        AppConstants.parcelRefundCreate,
        {
          "trip_request_id": tripId,
          "reason": refundReason,
          "parcel_approximate_price": productApproximatePrice.toString(),
          "customer_note": refundNote ?? '',
        },
        MultipartBody('', null),
        proofImage
    );
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