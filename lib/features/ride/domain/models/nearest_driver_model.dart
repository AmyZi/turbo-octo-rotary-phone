class NearestDriverModel {
  List<Nearest>? data;
  NearestDriverModel(
      {this.data,});

  NearestDriverModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Nearest>[];
      json['data'].forEach((v) {
        data!.add(Nearest.fromJson(v));
      });
    }
  }
}

class Nearest {

  String? latitude;
  String? longitude;
  String? category;


  Nearest(
      {
        this.latitude,
        this.longitude,
        this.category
       });

  Nearest.fromJson(Map<String, dynamic> json) {

    latitude = json['latitude'];
    longitude = json['longitude'];
    category = json['category'];

  }

}


