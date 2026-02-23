
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/features/refer_and_earn/domain/models/referral_details_model.dart';
import 'package:ride_sharing_user_app/features/refer_and_earn/domain/services/refer_earn_service_interface.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/models/transaction_model.dart';

class ReferAndEarnController extends GetxController implements GetxService {
  final ReferEarnServiceInterface referEarnServiceInterface;
  ReferAndEarnController({required this.referEarnServiceInterface});

  List<String> referAndEarnType = ['referral_details','earning'];
  int currentTabIndex = 0;
  bool isLoading = false;
  ScrollController scrollController = ScrollController();

  void updateCurrentTabIndex(int index, {bool isUpdate = false}){
    currentTabIndex = index;
    if(isUpdate){
      update();
    }
  }

  TransactionModel? referralModel;
  ReferralDetailsModel? referralDetails;

  Future<Response> getEarningHistoryList (int offset) async{
    isLoading = true;
    update();
    Response response = await referEarnServiceInterface.getEarningHistoryList(offset);
    if (response.statusCode == 200) {
      isLoading = false;
      if(offset == 1){
        referralModel = TransactionModel.fromJson(response.body);
      }else{
        referralModel!.data!.addAll(TransactionModel.fromJson(response.body).data!);
        referralModel!.offset = TransactionModel.fromJson(response.body).offset;
        referralModel!.totalSize = TransactionModel.fromJson(response.body).totalSize;
      }

    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  Future<void> getReferralDetails() async{
    isLoading = true;
    update();
    Response response = await referEarnServiceInterface.getReferralDetails();
    if(response.statusCode == 200){
      referralDetails = ReferralDetailsModel.fromJson(response.body);
      isLoading = false;
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
  }
}