import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/interface/repository_interface.dart';

abstract class RefundRequestRepositoryInterface implements RepositoryInterface{
  Future<dynamic> getParcelRefundReasonList();
  Future<dynamic> sendRefundRequest({
    required String tripId,
    required String refundReason,
    String? refundNote,
    required double productApproximatePrice,
    required List<MultipartBody> proofImage,
  });
}