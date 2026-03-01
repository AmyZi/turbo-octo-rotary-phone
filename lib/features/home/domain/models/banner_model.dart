class BannerModel {
  int? totalSize;
  String? limit;
  String? offset;
  List<Banner>? data;

  BannerModel({this.totalSize, this.limit, this.offset, this.data});

  BannerModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = <Banner>[];
      json['data'].forEach((v) {
        data!.add(Banner.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Banner {
  String? id;
  String? name;
  String? description;
  String? timePeriod;
  String? displayPosition;
  String? redirectLink;
  String? bannerGroup;
  String? startDate;
  String? endDate;
  String? image;

  Banner(
      {this.id,
        this.name,
        this.description,
        this.timePeriod,
        this.displayPosition,
        this.redirectLink,
        this.bannerGroup,
        this.startDate,
        this.endDate,
        this.image});

  Banner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    timePeriod = json['time_period'];
    displayPosition = json['display_position'];
    redirectLink = json['redirect_link'];
    bannerGroup = json['banner_group'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['time_period'] = timePeriod;
    data['display_position'] = displayPosition;
    data['redirect_link'] = redirectLink;
    data['banner_group'] = bannerGroup;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['image'] = image;
    return data;
  }
}
