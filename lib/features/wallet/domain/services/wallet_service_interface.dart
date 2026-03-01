abstract class WalletServiceInterface{
  Future<dynamic> getTransactionList(int offset);
  Future<dynamic> getLoyaltyPointList(int offset);
  Future<dynamic> convertPoint(String point);
  Future<dynamic> transferWalletMoney(String balance);
  Future<dynamic> getAddFundPromotionalList();
}