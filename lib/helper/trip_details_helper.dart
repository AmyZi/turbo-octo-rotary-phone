import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/auth/domain/enums/refund_status_enum.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';

class TripDetailsHelper{

  static bool isShowSafetyFeature(TripDetails tripDetails){
    if(tripDetails.rideCompleteTime != null){
      int time = DateTime.now().difference(DateConverter.dateTimeStringToDate(tripDetails.rideCompleteTime!)).inSeconds;
      int activeTime = (Get.find<ConfigController>().config?.afterTripCompleteSafetyFeatureSetTime ?? 0);
      return (Get.find<ConfigController>().config?.afterTripCompleteSafetyFeatureActiveStatus ?? false) && tripDetails.currentStatus ==  "completed" &&
          tripDetails.type != "parcel" && activeTime > time && tripDetails.customerSafetyAlert == null ? true : false;
    }else{
      return false;
    }
  }

  static bool isShowRefundRequestButton(RideController rideController){
    return (Get.find<ConfigController>().config?.parcelRefundStatus ?? false) &&
        isRefundTimeValid(rideController.tripDetails?.parcelCompleteTime ?? '2000-09-21 14:42:07') &&
        rideController.tripDetails?.type == 'parcel' && rideController.tripDetails?.currentStatus == 'completed' &&
        rideController.tripDetails?.parcelRefund == null;
  }

  static bool isRefundTimeValid(String stringDateTime){
    int time = Get.find<ConfigController>().config?.parcelRefundValidityType == 'hour' ?
    DateTime.now().difference(DateConverter.dateTimeStringToDate(stringDateTime)).inHours :
    DateTime.now().difference(DateConverter.dateTimeStringToDate(stringDateTime)).inDays;

    return time > (Get.find<ConfigController>().config?.parcelRefundValidity ?? 0) ? false : true;
  }

  static bool isReviewButtonShow(RideController rideController){
    return Get.find<ConfigController>().config!.reviewStatus! &&
        ! (rideController.tripDetails?.isReviewed ?? false) &&
        rideController.tripDetails?.driver != null &&
        rideController.tripDetails?.paymentStatus == 'paid' &&
        _checkRefundStatus(rideController.tripDetails?.parcelRefund?.status);
  }


  static bool _checkRefundStatus(RefundStatus? refundStatus){
    return refundStatus == RefundStatus.pending ?
    false :
    refundStatus == RefundStatus.approved ?
    false :
    true;
  }

}