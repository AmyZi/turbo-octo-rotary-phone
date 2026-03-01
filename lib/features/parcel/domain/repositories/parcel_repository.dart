import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/parcel/domain/repositories/parcel_repository_interface.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class ParcelRepository implements ParcelRepositoryInterface{
  final ApiClient apiClient;
  ParcelRepository({required this.apiClient});

  @override
  Future<Response> getParcelCategory() async {
    return await apiClient.getData(AppConstants.parcelCategoryUri);
  }

  @override
  Future<Response> getSuggestedVehicleCategory(String weight) async {
    return await apiClient.getData('${AppConstants.suggestedVehicleCategory}$weight');
  }

  @override
  Future<Response> getRunningParcelList(int offset) async {
    return await apiClient.getData(AppConstants.parcelOngoingList);
  }
  @override
  Future<Response> getUnpaidParcelList(int offset) async {
    return await apiClient.getData(AppConstants.parcelUnpaidList);
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