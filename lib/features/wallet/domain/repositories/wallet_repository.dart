import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/repositories/wallet_repository_interface.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class WalletRepository implements WalletRepositoryInterface{
  final ApiClient apiClient;

  WalletRepository({required this.apiClient});



  @override
  Future<Response?> getTransactionList(int offset) async {
    return await apiClient.getData('${AppConstants.transactionListUri}$offset');
  }

  @override
  Future<Response?> getLoyaltyPointList(int offset) async {
    return await apiClient.getData('${AppConstants.loyaltyPointListUri}$offset');
  }

  @override
  Future<Response?> convertPoint(String point) async {
    return await apiClient.postData(AppConstants.pointConvert,{
      'points' : point
    });
  }

  @override
  Future<Response> transferWalletMoney(String balance) async{
    return await apiClient.postData(AppConstants.transferMoneyFromDrivemondToMart, {"amount":balance});
  }

  @override
  Future<Response> getAddFundPromotionalList() async{
    return await apiClient.getData(AppConstants.getAddFundPromotionalList);
  }

}