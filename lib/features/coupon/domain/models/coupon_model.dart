class CouponModel {
  String? responseCode;
  String? message;
  int? totalSize;
  String? limit;
  String? offset;
  List<Coupon>? data;

  CouponModel(
      {this.responseCode,
        this.message,
        this.totalSize,
        this.limit,
        this.offset,
        this.data,
      });

  CouponModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = <Coupon>[];
      json['data'].forEach((v) {
        data!.add(Coupon.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response_code'] = responseCode;
    data['message'] = message;
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Coupon {
  String? id;
  String? name;
  String? description;
  List<String>? zoneCoupon;
  List<String>? customerLevelCoupon;
  List<String>? customerCoupon;
  List<String>? categoryCoupon;
  String? minTripAmount;
  String? maxCouponAmount;
  String? coupon;
  String? amountType;
  String? couponType;
  String? couponCode;
  int? limit;
  String? startDate;
  String? endDate;
  int? isActive;
  bool? isApplied;
  String? createdAt;
  bool isLoading = false;
  String? imageUrl;

  Coupon(
      {this.id,
        this.name,
        this.description,
        this.zoneCoupon,
        this.customerLevelCoupon,
        this.customerCoupon,
        this.categoryCoupon,
        this.minTripAmount,
        this.maxCouponAmount,
        this.coupon,
        this.amountType,
        this.couponType,
        this.couponCode,
        this.limit,
        this.startDate,
        this.endDate,
        this.isActive,
        this.isApplied,
        this.createdAt,
        this.isLoading = false,
        this.imageUrl
      });

  Coupon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    zoneCoupon = json['zone_coupon'].cast<String>();
    customerLevelCoupon = json['customer_level_coupon'].cast<String>();
    customerCoupon = json['customer_coupon'].cast<String>();
    categoryCoupon = json['category_coupon'].cast<String>();
    minTripAmount = json['min_trip_amount'];
    maxCouponAmount = json['max_coupon_amount'];
    coupon = json['coupon'];
    amountType = json['amount_type'];
    couponType = json['coupon_type'];
    couponCode = json['coupon_code'];
    limit = json['limit'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    isActive = json['is_active'];
    isApplied = json['is_applied'];
    createdAt = json['created_at'];
    imageUrl = json['category_coupon_image'];
    isLoading = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['zone_coupon'] = zoneCoupon;
    data['customer_level_coupon'] = customerLevelCoupon;
    data['customer_coupon'] = customerCoupon;
    data['category_coupon'] = categoryCoupon;
    data['min_trip_amount'] = minTripAmount;
    data['max_coupon_amount'] = maxCouponAmount;
    data['coupon'] = coupon;
    data['amount_type'] = amountType;
    data['coupon_type'] = couponType;
    data['coupon_code'] = couponCode;
    data['limit'] = limit;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['is_active'] = isActive;
    data['is_applied'] = isApplied;
    data['created_at'] = createdAt;
    data['category_coupon_image'] = imageUrl;
    return data;
  }
}