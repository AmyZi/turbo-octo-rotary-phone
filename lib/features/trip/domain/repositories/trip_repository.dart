import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/trip/domain/repositories/trip_repository_interface.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class TripRepository implements TripRepositoryInterface{
  final ApiClient apiClient;
  TripRepository({required this.apiClient});

  @override
  Future<Response> getTripList(String tripType, int offset, String from, String to, String filter,String status) async {
    return await apiClient.getData('${AppConstants.tripList}?type=ride_request&limit=20&offset=$offset&filter=$filter&start=$from&end=$to&status=$status');
  }

  @override
  Future getRideCancellationReasonList() async{
    return await apiClient.getData(AppConstants.rideCancellationReasonList);
  }

  @override
  Future getParcelCancellationReasonList() async{
    return await apiClient.getData(AppConstants.parcelCancellationReasonList);
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset = 1}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(value, {int? id}) {
    // TODO: implement update
    throw UnimplementedError();
  }
  

}