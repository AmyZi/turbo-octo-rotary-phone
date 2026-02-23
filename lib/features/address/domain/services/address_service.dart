import 'package:ride_sharing_user_app/features/address/domain/models/address_model.dart';
import 'package:ride_sharing_user_app/features/address/domain/repositories/address_repository_interface.dart';
import 'package:ride_sharing_user_app/features/address/domain/services/address_service_interface.dart';

class AddressService implements AddressServiceInterface{
  AddressRepositoryInterface addressRepositoryInterface;

  AddressService({required this.addressRepositoryInterface});

  @override
  Future add(Address address) async{
    return await addressRepositoryInterface.add(address);
  }

  @override
  Future delete(String id) async{
    return await addressRepositoryInterface.delete(id);
  }

  @override
  Future getList({int? offset = 1}) async{
    return await addressRepositoryInterface.getList(offset: offset);
  }

  @override
  Future update(Address address) async{
    return await addressRepositoryInterface.update(address);
  }

  @override
  Future updateLastLocation(String lat, String lng, String zoneID) {
    return addressRepositoryInterface.updateLastLocation(lat, lng, zoneID);
  }

}