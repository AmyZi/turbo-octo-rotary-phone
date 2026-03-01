import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/features/my_offer/domain/models/best_offer_model.dart';
import 'package:ride_sharing_user_app/features/my_offer/domain/services/offer_service_interface.dart';

class OfferController extends GetxController implements GetxService{
  final OfferServiceInterface offerServiceInterface;
  OfferController({required this.offerServiceInterface});

  bool isLoading = false;
  BestOfferModel? bestOfferModel;
  int currentTabIndex = 0;
  List<String> offerType = ['discounts', 'coupons'];


  Future<Response> getOfferList(int offset) async {
    isLoading = true;
    Response response = await offerServiceInterface.getOfferList(offset);
    if(response.statusCode == 200 ){
      isLoading = false;
      if(offset == 1){
        bestOfferModel = BestOfferModel.fromJson(response.body);
      }else{
        bestOfferModel?.data!.addAll(BestOfferModel.fromJson(response.body).data!);
        bestOfferModel?.offset = BestOfferModel.fromJson(response.body).offset;
        bestOfferModel?.totalSize = BestOfferModel.fromJson(response.body).totalSize;
      }
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    isLoading = false;
    update();
    return response;
  }

  void setCurrentTabIndex(int index, {bool isUpdate = true}){
    currentTabIndex = index;

    if(isUpdate){
      update();
    }
  }
}