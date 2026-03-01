import 'package:ride_sharing_user_app/features/trip/domain/repositories/trip_repository_interface.dart';
import 'package:ride_sharing_user_app/features/trip/domain/services/service_interface.dart';

class TripService implements TripServiceInterface{
  TripRepositoryInterface tripRepositoryInterface;
  TripService({required this.tripRepositoryInterface});

  @override
  Future getTripList(String tripType, int offset, String from, String to, String filter,String status) async{
   return await tripRepositoryInterface.getTripList(tripType, offset, from, to, filter,status);
  }

  @override
  Future getRideCancellationReasonList() async{
    return await tripRepositoryInterface.getRideCancellationReasonList();
  }

  @override
  Future getParcelCancellationReasonList() async{
    return await tripRepositoryInterface.getParcelCancellationReasonList();
  }

}