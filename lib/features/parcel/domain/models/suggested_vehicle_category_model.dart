class SuggestedVehicleCategoryModel {
  String? responseCode;
  Data? data;


  SuggestedVehicleCategoryModel(
      {this.responseCode,
        this.data,
        });

  SuggestedVehicleCategoryModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;

  }


}

class Data {
  int? currentPage;
  List<SuggestedCategory>? data;
  int? total;

  Data(
      {this.currentPage,
        this.data,
        this.total});

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <SuggestedCategory>[];
      json['data'].forEach((v) {
        data!.add(SuggestedCategory.fromJson(v));
      });
    }

    total = json['total'];
  }


}

class SuggestedCategory {
  String? id;
  String? name;
  String? description;
  String? image;
  String? type;
  int? isActive;



  SuggestedCategory(
      {this.id,
        this.name,
        this.description,
        this.image,
        this.type,
        this.isActive,
      });

  SuggestedCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    type = json['type'];
    isActive = json['is_active'] ? 1 : 0;
  }

}

