import 'package:ride_sharing_user_app/features/wallet/domain/repositories/wallet_repository_interface.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/services/wallet_service_interface.dart';

class WalletService implements WalletServiceInterface{
  WalletRepositoryInterface walletRepositoryInterface;

  WalletService({required this.walletRepositoryInterface});

  @override
  Future convertPoint(String point) async{
    return await walletRepositoryInterface.convertPoint(point);
  }

  @override
  Future getLoyaltyPointList(int offset) async{
    return await walletRepositoryInterface.getLoyaltyPointList(offset);
  }

  @override
  Future getTransactionList(int offset) async{
    return await walletRepositoryInterface.getTransactionList(offset);
  }

  @override
  Future transferWalletMoney(String balance) async{
    return await walletRepositoryInterface.transferWalletMoney(balance);
  }

  @override
  Future getAddFundPromotionalList() async{
    return await walletRepositoryInterface.getAddFundPromotionalList();
  }
}