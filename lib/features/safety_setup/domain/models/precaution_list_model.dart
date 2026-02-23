class PrecautionListModel {
  String? responseCode;
  String? message;
  int? totalSize;
  int? limit;
  int? offset;
  List<Data>? data;
  List<String>? errors;

  PrecautionListModel(
      {this.responseCode,
        this.message,
        this.totalSize,
        this.limit,
        this.offset,
        this.data,
        this.errors});

  PrecautionListModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add( Data.fromJson(v));
      });
    }
    errors = json['errors'].cast<String>();
  }
}

class Data {
  String? title;
  String? description;

  Data({this.title, this.description});

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
  }
}
