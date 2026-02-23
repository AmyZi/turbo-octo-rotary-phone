class PlaceDetailsModel {
  String? responseCode;
  String? message;
  int? totalSize;
  int? limit;
  int? offset;
  Data? data;
  List<String>? errors;

  PlaceDetailsModel(
      {this.responseCode,
        this.message,
        this.totalSize,
        this.limit,
        this.offset,
        this.data,
        this.errors});

  PlaceDetailsModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    errors = json['errors'].cast<String>();
  }

}

class Data {
  String? name;
  String? id;
  List<String>? types;
  String? formattedAddress;
  List<AddressComponents>? addressComponents;
  Location? location;
  Viewport? viewport;
  String? googleMapsUri;
  int? utcOffsetMinutes;
  String? adrFormatAddress;
  String? iconMaskBaseUri;
  String? iconBackgroundColor;
  DisplayName? displayName;
  String? shortFormattedAddress;
  List<Photos>? photos;
  bool? pureServiceAreaBusiness;
  GoogleMapsLinks? googleMapsLinks;
  TimeZone? timeZone;

  Data(
      {this.name,
        this.id,
        this.types,
        this.formattedAddress,
        this.addressComponents,
        this.location,
        this.viewport,
        this.googleMapsUri,
        this.utcOffsetMinutes,
        this.adrFormatAddress,
        this.iconMaskBaseUri,
        this.iconBackgroundColor,
        this.displayName,
        this.shortFormattedAddress,
        this.photos,
        this.pureServiceAreaBusiness,
        this.googleMapsLinks,
        this.timeZone});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    types = json['types'].cast<String>();
    formattedAddress = json['formattedAddress'];
    if (json['addressComponents'] != null) {
      addressComponents = <AddressComponents>[];
      json['addressComponents'].forEach((v) {
        addressComponents!.add(AddressComponents.fromJson(v));
      });
    }
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
    viewport = json['viewport'] != null
        ? Viewport.fromJson(json['viewport'])
        : null;
    googleMapsUri = json['googleMapsUri'];
    utcOffsetMinutes = json['utcOffsetMinutes'];
    adrFormatAddress = json['adrFormatAddress'];
    iconMaskBaseUri = json['iconMaskBaseUri'];
    iconBackgroundColor = json['iconBackgroundColor'];
    displayName = json['displayName'] != null
        ? DisplayName.fromJson(json['displayName'])
        : null;
    shortFormattedAddress = json['shortFormattedAddress'];
    if (json['photos'] != null) {
      photos = <Photos>[];
      json['photos'].forEach((v) {
        photos!.add(Photos.fromJson(v));
      });
    }
    pureServiceAreaBusiness = json['pureServiceAreaBusiness'];
    googleMapsLinks = json['googleMapsLinks'] != null
        ? GoogleMapsLinks.fromJson(json['googleMapsLinks'])
        : null;
    timeZone = json['timeZone'] != null
        ? TimeZone.fromJson(json['timeZone'])
        : null;
  }


}

class AddressComponents {
  String? longText;
  String? shortText;
  List<String>? types;
  String? languageCode;

  AddressComponents(
      {this.longText, this.shortText, this.types, this.languageCode});

  AddressComponents.fromJson(Map<String, dynamic> json) {
    longText = json['longText'];
    shortText = json['shortText'];
    types = json['types'].cast<String>();
    languageCode = json['languageCode'];
  }

}

class Location {
  double? latitude;
  double? longitude;

  Location({this.latitude, this.longitude});

  Location.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

}

class Viewport {
  Location? low;
  Location? high;

  Viewport({this.low, this.high});

  Viewport.fromJson(Map<String, dynamic> json) {
    low = json['low'] != null ? Location.fromJson(json['low']) : null;
    high = json['high'] != null ? Location.fromJson(json['high']) : null;
  }

}

class DisplayName {
  String? text;
  String? languageCode;

  DisplayName({this.text, this.languageCode});

  DisplayName.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    languageCode = json['languageCode'];
  }

}

class Photos {
  String? name;
  int? widthPx;
  int? heightPx;
  List<AuthorAttributions>? authorAttributions;
  String? flagContentUri;
  String? googleMapsUri;

  Photos(
      {this.name,
        this.widthPx,
        this.heightPx,
        this.authorAttributions,
        this.flagContentUri,
        this.googleMapsUri});

  Photos.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    widthPx = json['widthPx'];
    heightPx = json['heightPx'];
    if (json['authorAttributions'] != null) {
      authorAttributions = <AuthorAttributions>[];
      json['authorAttributions'].forEach((v) {
        authorAttributions!.add(AuthorAttributions.fromJson(v));
      });
    }
    flagContentUri = json['flagContentUri'];
    googleMapsUri = json['googleMapsUri'];
  }

}

class AuthorAttributions {
  String? displayName;
  String? uri;
  String? photoUri;

  AuthorAttributions({this.displayName, this.uri, this.photoUri});

  AuthorAttributions.fromJson(Map<String, dynamic> json) {
    displayName = json['displayName'];
    uri = json['uri'];
    photoUri = json['photoUri'];
  }

}

class GoogleMapsLinks {
  String? directionsUri;
  String? placeUri;
  String? photosUri;

  GoogleMapsLinks({this.directionsUri, this.placeUri, this.photosUri});

  GoogleMapsLinks.fromJson(Map<String, dynamic> json) {
    directionsUri = json['directionsUri'];
    placeUri = json['placeUri'];
    photosUri = json['photosUri'];
  }

}

class TimeZone {
  String? id;

  TimeZone({this.id});

  TimeZone.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

}