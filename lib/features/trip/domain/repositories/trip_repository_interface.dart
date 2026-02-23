import 'package:ride_sharing_user_app/interface/repository_interface.dart';

abstract class TripRepositoryInterface implements RepositoryInterface{
  Future<dynamic> getTripList(String tripType, int offset, String from, String to, String filter,String status);
  Future<dynamic> getRideCancellationReasonList();
  Future<dynamic> getParcelCancellationReasonList();
}