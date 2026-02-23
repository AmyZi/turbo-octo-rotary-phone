import 'package:ride_sharing_user_app/features/coupon/domain/repositories/coupon_repository_interface.dart';
import 'package:ride_sharing_user_app/features/coupon/domain/services/coupon_service_interface.dart';

class CouponService implements CouponServiceInterface{
  CouponRepositoryInterface couponRepositoryInterface;

  CouponService({required this.couponRepositoryInterface});

  @override
  Future getCouponList(String categoryType, {int? offset = 1}) async{
    return await couponRepositoryInterface.getCouponList(categoryType, offset: offset);
  }

  @override
  Future customerAppliedCoupon(String couponId) async{
    return await couponRepositoryInterface.customerAppliedCoupon(couponId);
  }

}