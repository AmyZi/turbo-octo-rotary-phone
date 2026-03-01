import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/models/add_fund_promotional_model.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/models/loyalty_point_model.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/models/transaction_model.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/services/wallet_service.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';


class WalletController extends GetxController implements GetxService{
  final WalletService walletService;

  WalletController({required this.walletService});

  TextEditingController inputController = TextEditingController();
  FocusNode inputNode = FocusNode();
  ScrollController scrollController = ScrollController();

  bool isLoading = false;

  List<String> walletType = ['wallet_money','loyalty_point'];

  TransactionModel? transactionModel;
  Future<Response> getTransactionList(int offset) async {
    isLoading = true;
    update();
    Response? response = await walletService.getTransactionList(offset);
    if (response!.statusCode == 200) {
      isLoading = false;
      if(offset == 1){
        transactionModel = TransactionModel.fromJson(response.body);
      }else{
        transactionModel!.data!.addAll(TransactionModel.fromJson(response.body).data!);
        transactionModel!.offset = TransactionModel.fromJson(response.body).offset;
        transactionModel!.totalSize = TransactionModel.fromJson(response.body).totalSize;
      }

    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }
  AddFundPromotionalModel? addFundPromotionalModel;
  LoyaltyPointModel? loyaltyPointModel;
  Future<Response> getLoyaltyPointList(int offset) async {
    isLoading = true;
    update();
    Response? response = await walletService.getLoyaltyPointList(offset);
    if (response!.statusCode == 200) {
      isLoading = false;
      if(offset == 1){
        loyaltyPointModel = LoyaltyPointModel.fromJson(response.body);
      }else{
        loyaltyPointModel!.data!.addAll(LoyaltyPointModel.fromJson(response.body).data!);
        loyaltyPointModel!.offset = LoyaltyPointModel.fromJson(response.body).offset;
        loyaltyPointModel!.totalSize = LoyaltyPointModel.fromJson(response.body).totalSize;
      }
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }



  Future<Response> convertPoint(String point) async {
    isLoading = true;
    update();
    Response? response = await walletService.convertPoint(point);
    if (response!.statusCode == 200) {
     Get.find<ProfileController>().getProfileInfo();
     getTransactionList(1);
      isLoading = false;
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  int currentTabIndex = 0;

  void updateCurrentTabIndex(int index, {bool isUpdate = false}){
    currentTabIndex = index;
    if(index == 0){
      getTransactionList(1);
    }else{
      getLoyaltyPointList(1);
    }
    if(isUpdate){
      update();
    }
  }

  Future<void> transferWalletMoney(String balance) async{
    isLoading = true;
    update();
    Response response = await walletService.transferWalletMoney(balance);
    if(response.statusCode == 200){
      isLoading = false;
      getTransactionList(1);
      Get.find<ProfileController>().getProfileInfo();
      Get.back();
      showCustomSnackBar('transfer_successfully'.tr,isError: false);
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getAddFundPromotionalList() async{
    Response response = await walletService.getAddFundPromotionalList();
    if(response.statusCode == 200){
      addFundPromotionalModel = AddFundPromotionalModel.fromJson(response.body);
    }else{
      ApiChecker.checkApi(response);
    }
    update();
  }

}