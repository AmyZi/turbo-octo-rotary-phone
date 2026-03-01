class LastLocationModel {
  int? id;
  String? userId;
  String? type;
  String? latitude;
  String? longitude;
  String? zoneId;
  String? createdAt;
  String? updatedAt;

  LastLocationModel(
      {this.id,
        this.userId,
        this.type,
        this.latitude,
        this.longitude,
        this.zoneId,
        this.createdAt,
        this.updatedAt});

  LastLocationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    zoneId = json['zone_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
