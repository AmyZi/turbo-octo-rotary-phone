abstract class CouponServiceInterface{
  Future<dynamic> getCouponList(String categoryType, {int? offset = 1});
  Future<dynamic> customerAppliedCoupon(String couponId);
}