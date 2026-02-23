import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/refund_request/domain/repositories/refund_request_repository_interface.dart';
import 'package:ride_sharing_user_app/features/refund_request/domain/services/refund_request_service_interface.dart';

class RefundRequestService implements RefundRequestServiceInterface {
  RefundRequestRepositoryInterface refundRequestRepositoryInterface;
  RefundRequestService({required this.refundRequestRepositoryInterface});

  @override
  Future getParcelRefundReasonList() async{
    return await refundRequestRepositoryInterface.getParcelRefundReasonList();
  }

  @override
  Future sendRefundRequest({
    required String tripId,
    required String refundReason,
    String? refundNote,
    required double productApproximatePrice,
    required List<MultipartBody> proofImage,
  }) async{
    return await refundRequestRepositoryInterface.sendRefundRequest(
      tripId: tripId,
      refundReason: refundReason,
      refundNote: refundNote,
      productApproximatePrice: productApproximatePrice,
      proofImage: proofImage,
    );
  }
}