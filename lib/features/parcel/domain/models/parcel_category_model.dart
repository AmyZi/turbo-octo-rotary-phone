class ParcelCategoryModel {
  String? responseCode;
  String? message;
  int? totalSize;
  String? limit;
  String? offset;
  List<ParcelCategory>? data;


  ParcelCategoryModel(
      {this.responseCode,
        this.message,
        this.totalSize,
        this.limit,
        this.offset,
        this.data
      });

  ParcelCategoryModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = <ParcelCategory>[];
      json['data'].forEach((v) {
        data!.add(ParcelCategory.fromJson(v));
      });
    }

  }

}

class ParcelCategory {
  String? id;
  String? name;
  String? description;
  String? image;
  int? isActive;
  List<WeightFares>? weightFares;
  String? createdAt;

  ParcelCategory(
      {this.id,
        this.name,
        this.description,
        this.image,
        this.isActive,
        this.weightFares,
        this.createdAt});

  ParcelCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    isActive = json['is_active'] ? 1 : 0;
    if (json['weight_fares'] != null) {
      weightFares = <WeightFares>[];
      json['weight_fares'].forEach((v) {
        weightFares!.add(WeightFares.fromJson(v));
      });
    }
    createdAt = json['created_at'];
  }

}

class WeightFares {
  int? id;
  ParcelFare? parcelFare;
  ParcelWeight? parcelWeight;
  double? fare;
  String? createdAt;

  WeightFares(
      {this.id, this.parcelFare, this.parcelWeight, this.fare, this.createdAt});

  WeightFares.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parcelFare = json['parcel_fare'] != null
        ? ParcelFare.fromJson(json['parcel_fare'])
        : null;
    parcelWeight = json['parcel_weight'] != null
        ? ParcelWeight.fromJson(json['parcel_weight'])
        : null;
    if(json['fare'] != null){
      fare = json['fare'].toDouble();
    }

    createdAt = json['created_at'];
  }

}

class ParcelFare {
  String? id;
  double? baseFare;
  double? baseFarePerKm;
  double? cancellationFeePercent;
  double? minCancellationFee;
  String? createdAt;

  ParcelFare(
      {this.id,
        this.baseFare,
        this.baseFarePerKm,
        this.cancellationFeePercent,
        this.minCancellationFee,
        this.createdAt});

  ParcelFare.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if(json['base_fare'] != null){
      baseFare = json['base_fare'].toDouble();
    }
    if(json['base_fare_per_km'] != null){
      baseFarePerKm = json['base_fare_per_km'].toDouble();
    }

   if(json['cancellation_fee_percent'] != null){
     cancellationFeePercent = json['cancellation_fee_percent'].toDouble();
   }
    if(json['min_cancellation_fee'] != null){
      minCancellationFee = json['min_cancellation_fee'].toDouble();
    }

    createdAt = json['created_at'];
  }

}

class ParcelWeight {
  String? id;
  double? minWeight;
  double? maxWeight;
  String? createdAt;

  ParcelWeight(
      {this.id, this.minWeight, this.maxWeight, this.createdAt});

  ParcelWeight.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if(json['min_weight'] != null){
      minWeight = json['min_weight'].toDouble();
    }
    if(json['max_weight'] != null){
      maxWeight = json['max_weight'].toDouble();
    }

    createdAt = json['created_at'];
  }

}
