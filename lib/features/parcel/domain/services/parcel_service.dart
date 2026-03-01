import 'package:ride_sharing_user_app/features/parcel/domain/repositories/parcel_repository_interface.dart';
import 'package:ride_sharing_user_app/features/parcel/domain/services/parcel_service_interface.dart';

class ParcelService implements ParcelServiceInterface{
  ParcelRepositoryInterface parcelRepositoryInterface;

  ParcelService({required this.parcelRepositoryInterface});

  @override
  Future getRunningParcelList(int offset) async{
   return await parcelRepositoryInterface.getRunningParcelList(offset);
  }

  @override
  Future getParcelCategory() async{
    return await parcelRepositoryInterface.getParcelCategory();
  }

  @override
  Future getSuggestedVehicleCategory(String weight) async{
   return await parcelRepositoryInterface.getSuggestedVehicleCategory(weight);
  }

  @override
  Future getUnpaidParcelList(int offset) async{
    return await parcelRepositoryInterface.getUnpaidParcelList(offset);
  }

}