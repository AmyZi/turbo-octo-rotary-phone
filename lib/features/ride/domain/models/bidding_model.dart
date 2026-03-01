import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';

class BiddingModel {
  int? totalSize;
  String? limit;
  String? offset;
  List<Bidding>? data;


  BiddingModel(
      {
        this.totalSize,
        this.limit,
        this.offset,
        this.data
      });

  BiddingModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = <Bidding>[];
      json['data'].forEach((v) {
        data!.add(Bidding.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;


    return data;
  }
}

class Bidding {
  String? id;
  String? tripRequestsId;
  Driver? driver;
  DriverLastLocation? driverLastLocation;
  double? bidFare;
  String? driverAvgRating;

  Bidding(
      {this.id,
        this.tripRequestsId,
        this.driver,
        this.driverLastLocation,
        this.bidFare,
        this.driverAvgRating});

  Bidding.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tripRequestsId = json['trip_requests_id'];
    driver =
    json['driver'] != null ? Driver.fromJson(json['driver']) : null;

    driverLastLocation = json['driver_last_location'] != null
        ? DriverLastLocation.fromJson(json['driver_last_location'])
        : null;
    bidFare = json['bid_fare'] != null ? double.parse(json['bid_fare'].toString()) : 0;
    driverAvgRating = json['driver_avg_rating'];
  }


}
class DriverLastLocation {
  String? userId;
  String? type;
  String? latitude;
  String? longitude;
  String? zoneId;

  DriverLastLocation(
      {this.userId, this.type, this.latitude, this.longitude, this.zoneId});

  DriverLastLocation.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    type = json['type'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    zoneId = json['zone_id'];
  }


}
