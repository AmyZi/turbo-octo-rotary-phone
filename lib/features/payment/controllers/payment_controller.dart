import 'dart:developer';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/features/map/screens/map_screen.dart';
import 'package:ride_sharing_user_app/features/payment/domain/services/payment_service_interface.dart';
import 'package:ride_sharing_user_app/features/payment/screens/review_screen.dart';
import 'package:ride_sharing_user_app/features/splash/domain/models/config_model.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/features/dashboard/controllers/bottom_menu_controller.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';

enum PaymentType{cash, digital, wallet}

class PaymentController extends GetxController implements GetxService{
  final PaymentServiceInterface paymentServiceInterface;
  PaymentController({required this.paymentServiceInterface});

  List<ReviewModel> reviewTypeList  = [
    ReviewModel(Images.notGood, 'not_good'),
    ReviewModel(Images.good, 'good'),
    ReviewModel(Images.satisfied, 'satisfied'),
    ReviewModel(Images.lovely, 'lovely'),
    ReviewModel(Images.superb, 'superb'),
  ];
  List<String> paymentTypeList = ['cash', 'digital', 'wallet'];


  bool isLoading = false;
  int reviewTypeSelectedIndex = 4;
  int paymentTypeIndex = 0;
  int paymentGatewayIndex = -1;
  String tipAmount = '0';

  void initPayment() {
    isLoading = false;
    reviewTypeSelectedIndex = 3;
    paymentGatewayIndex = -1;
    paymentTypeIndex = 0;
    tipAmount = '0';
  }

  void setReviewType(int index){
    reviewTypeSelectedIndex = index;
    update();
  }

  String paymentType = 'cash';
  void setPaymentType(int index) {
    tipAmount = '0';
    paymentTypeIndex = index;
    paymentType = paymentTypeList[paymentTypeIndex];
    paymentServiceInterface.saveLastPaymentType(paymentType);
    update();

  }

  void setPaymentByName(String name) {
    if(name == 'cash'){
      paymentTypeIndex = 0;
    }else if(name == 'wallet'){
      paymentTypeIndex = 2;
    }else{
      paymentTypeIndex = 1;
    }

  }

  String gateWay = '';
  void setDigitalPaymentType(int index, String gateway) {
    paymentGatewayIndex = index;
    gateWay = Get.find<ConfigController>().config?.paymentGateways?[index].gateway??'ssl_commerz';
    log("===>44$gateWay");
    paymentServiceInterface.saveLastPaymentMethod(gateWay);
    update();
  }

  void setTipAmount(String amount){
    if(amount.isNotEmpty){
      tipAmount = amount;
    }else{
      tipAmount = '0';
    }

    update();
  }


  Future<Response> submitReview(String id, int ratting, String comment) async {
    isLoading = true;
    update();
    Response response = await paymentServiceInterface.submitReview(id, ratting, comment);
    if (response.statusCode == 200 ) {
      Get.back();
      showCustomSnackBar('review_submitted_successfully'.tr, isError: false);
      Get.find<BottomMenuController>().navigateToDashboard();
      isLoading = false;
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  Future<Response> paymentSubmit(String tripId, String paymentMethod, {bool fromParcel = false} ) async {
    isLoading = true;
    update();
    Response response = await paymentServiceInterface.paymentSubmit(tripId, paymentMethod);
    if (response.statusCode == 200 ) {
      Get.find<RideController>().clearRideDetails();
      Get.find<ProfileController>().getProfileInfo();
      showCustomSnackBar('payment_successful'.tr, isError: false);
      if(fromParcel){
        Get.find<RideController>().updateRideCurrentState(RideState.afterAcceptRider);
        Get.find<RideController>().getRideDetails(tripId).then((value){
          Get.offAll(() => const MapScreen(fromScreen: MapScreenType.parcel));
        });

      }else{
        if(Get.find<ConfigController>().config!.reviewStatus!){
          Get.offAll(()=> ReviewScreen(tripId: tripId));
        }else{
          Get.offAll(()=> const DashboardScreen());
        }

      }

      isLoading = false;
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  List<PaymentGateways>? paymentGateways = [];

  void getPaymentGetWayList() async{
    paymentGateways = [];
    Response response = await paymentServiceInterface.getPaymentGetWayList();
    if(response.statusCode == 200){
      response.body.forEach((v) {
        paymentGateways!.add(PaymentGateways.fromJson(v));
      });
      checkPreviousPaymentMethod();
    }else{
      ApiChecker.checkApi(response);
    }
    update();
  }

  void checkPreviousPaymentMethod(){
    String previousPaymentMethod =  paymentServiceInterface.getLastPaymentMethod();
    String previousPaymentType =  paymentServiceInterface.getLastPaymentType();
    for(int i = 0; i< paymentGateways!.length; i++){
      if(paymentGateways?[i].gateway == previousPaymentMethod){
        paymentGatewayIndex = i;
        gateWay = paymentGateways![i].gateway!;
      }
    }

    for(int i = 0; i< paymentTypeList.length; i++){
      if(paymentTypeList[i] == previousPaymentType){
        paymentTypeIndex = i;
        paymentType = paymentTypeList[i];
      }
    }

  }

}


class PaymentMethod {
  String name;
  String image;
  PaymentMethod(this.name, this.image);
}

class ReviewModel {
  String? icon;
  String? title;
  ReviewModel(this.icon, this.title);



}