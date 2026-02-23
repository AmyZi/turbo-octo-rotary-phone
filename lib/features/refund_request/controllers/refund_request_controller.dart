import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/refund_request/domain/models/refund_reason_model.dart';
import 'package:ride_sharing_user_app/features/refund_request/domain/services/refund_request_service_interface.dart';
import 'package:ride_sharing_user_app/features/refund_request/widgets/refund_request_send_success_bottomsheet.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/file_validation_helper.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class RefundRequestController extends GetxController implements GetxService {
  final RefundRequestServiceInterface refundRequestServiceInterface;
  RefundRequestController({required this.refundRequestServiceInterface});

  List<XFile> proofImages = [];

  int parcelRefundReasonCauseCurrentIndex = 0;
  RefundReasonModel? refundReasonModel;
  bool isLoading = false;
  List<MultipartBody> multipartList = [];
  List<String> thumbnailPaths = [];

  void pickProofImage(ImageSource source,bool isVideo)async {
    Get.back();
    XFile?  selectedImage;
    if(isVideo){
      selectedImage = await ImagePicker().pickVideo(source: source);
      if(selectedImage != null){
        if((File(selectedImage.path).lengthSync()) > (Get.find<ConfigController>().config?.maxFileUploadSize ?? 52428800)){
          showCustomSnackBar('${'video_length_maximum'.tr} ${(Get.find<ConfigController>().config?.maxFileUploadSize ?? 52428800)/(1024*1024)}');
        }else{
          proofImages.add(selectedImage);
          multipartList.add(MultipartBody('attachments[]', selectedImage));
          String? path = await generateThumbnail(selectedImage.path);
          thumbnailPaths.add(path ?? '');
        }
      }
    }else{
      selectedImage = await FileValidationHelper.validateAndPickImage(source: source);
      if(selectedImage != null){
        thumbnailPaths.add('');
        proofImages.add(selectedImage);
        multipartList.add(MultipartBody('attachments[]', selectedImage));

      }
    }
    update();
  }

  void removeImage(int index){
    proofImages.removeAt(index);
    multipartList.removeAt(index);
    thumbnailPaths.removeAt(index);
    update();
  }

  void getParcelRefundReasonList() async{
    Response response = await refundRequestServiceInterface.getParcelRefundReasonList();

    if(response.statusCode == 200){
      refundReasonModel = RefundReasonModel.fromJson(response.body);

    }else{
      ApiChecker.checkApi(response);
    }
  }

  void setParcelRefundCurrentIndex(int index){
    parcelRefundReasonCauseCurrentIndex = index;
    update();
  }


  void sendRefundRequest({required String tripId, required String refundReason, required String? refundNote, required double productApproximatePrice}) async{
    isLoading = true;
    update();
    Response response = await refundRequestServiceInterface.sendRefundRequest(
      tripId: tripId, refundReason: refundReason,
      refundNote: refundNote,
      productApproximatePrice: productApproximatePrice,
      proofImage: multipartList,
    );
    if(response.statusCode == 200){
      Get.back();
      onClearRefundData();

      isLoading = false;
     await Get.bottomSheet(RefundRequestSendSuccessBottomSheet(parcelId: tripId));
      Get.find<RideController>().getRideDetails(tripId);
    }else{
      ApiChecker.checkApi(response);
      isLoading = false;
    }
    update();
  }

  Future<String?> generateThumbnail(String filePath) async {
    final directory = await getTemporaryDirectory();

    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: filePath, // Replace with your video URL
      thumbnailPath: directory.path,
      imageFormat: ImageFormat.PNG,  // You can use JPEG or WEBP too
      maxHeight: 100,                 // Specify the height of the thumbnail
      maxWidth: 200,                 // Specify the Width of the thumbnail
      quality: 1,                    // Quality of the thumbnail
    );

    return thumbnailPath;
  }

  void onClearRefundData() {
    proofImages = [];
    multipartList = [];
    thumbnailPaths = [];
    parcelRefundReasonCauseCurrentIndex = 0;
  }

}