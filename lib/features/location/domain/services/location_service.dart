import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing_user_app/features/address/domain/models/address_model.dart';
import 'package:ride_sharing_user_app/features/location/domain/repositories/location_repository_interface.dart';
import 'package:ride_sharing_user_app/features/location/domain/services/location_service_interface.dart';

class LocationService implements LocationServiceInterface{
  LocationRepositoryInterface locationRepositoryInterface;
  LocationService({required this.locationRepositoryInterface});

  @override
  Future getAddressFromGeocode(LatLng? latLng) async{
    return await locationRepositoryInterface.getAddressFromGeocode(latLng);
  }

  @override
  Future getPlaceDetails(String placeID) async{
    return await locationRepositoryInterface.getPlaceDetails(placeID);
  }

  @override
  String? getUserAddress() {
    return locationRepositoryInterface.getUserAddress();
  }

  @override
  Future getZone(String lat, String lng) async{
    return await locationRepositoryInterface.getZone(lat, lng);
  }

  @override
  Future<bool> saveUserAddress(Address? address) async{
    return await locationRepositoryInterface.saveUserAddress(address);
  }

  @override
  Future searchLocation(String text) async{
    return await locationRepositoryInterface.searchLocation(text);
  }

}