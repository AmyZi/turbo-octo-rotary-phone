import 'package:ride_sharing_user_app/features/address/domain/models/address_model.dart';

abstract class AddressServiceInterface{

  Future<dynamic> add(Address address);

  Future<dynamic> update(Address address);

  Future<dynamic> delete(String id);

  Future<dynamic> getList({int? offset = 1});

  Future<dynamic> updateLastLocation(String lat, String lng, String zoneID);
}