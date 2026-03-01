class CategoryModel {
  String? responseCode;
  String? message;
  int? totalSize;
  String? limit;
  String? offset;
  List<Category>? data;


  CategoryModel(
      {this.responseCode,
        this.message,
        this.totalSize,
        this.limit,
        this.offset,
        this.data,
        });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = <Category>[];
      json['data'].forEach((v) {
        data!.add(Category.fromJson(v));
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

class Category {
  String? id;
  String? name;
  String? image;
  List<Fare>? fare;

  Category({this.id, this.name, this.image, this.fare});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    if (json['fare'] != null) {
      fare = <Fare>[];
      json['fare'].forEach((v) {
        fare!.add(Fare.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    if (fare != null) {
      data['fare'] = fare!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Fare {
  String? id;
  double? baseFare;
  double? baseFarePerKm;
  double? waitingFeePerMin;
  double? minCancellationFee;
  double? idleFeePerMin;
  double? tripDelayFeePerMin;
  double? penaltyFeeForCancel;
  double? feeAddToNext;
  String? createdAt;

  Fare(
      {this.id,
        this.baseFare,
        this.baseFarePerKm,
        this.waitingFeePerMin,
        this.minCancellationFee,
        this.idleFeePerMin,
        this.tripDelayFeePerMin,
        this.penaltyFeeForCancel,
        this.feeAddToNext,
        this.createdAt});

  Fare.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    baseFare = json['base_fare'].toDouble();
    baseFarePerKm = json['base_fare_per_km'].toDouble();
    waitingFeePerMin = json['waiting_fee_per_min'].toDouble();
    minCancellationFee = json['min_cancellation_fee'].toDouble();
    idleFeePerMin = json['idle_fee_per_min'].toDouble();
    tripDelayFeePerMin = json['trip_delay_fee_per_min'].toDouble();
    penaltyFeeForCancel = json['penalty_fee_for_cancel'].toDouble();
    feeAddToNext = json['fee_add_to_next'].toDouble();
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['base_fare'] = baseFare;
    data['base_fare_per_km'] = baseFarePerKm;
    data['waiting_fee_per_min'] = waitingFeePerMin;
    data['min_cancellation_fee'] = minCancellationFee;
    data['idle_fee_per_min'] = idleFeePerMin;
    data['trip_delay_fee_per_min'] = tripDelayFeePerMin;
    data['penalty_fee_for_cancel'] = penaltyFeeForCancel;
    data['fee_add_to_next'] = feeAddToNext;
    data['created_at'] = createdAt;
    return data;
  }
}
