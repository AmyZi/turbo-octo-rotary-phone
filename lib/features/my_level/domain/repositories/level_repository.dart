import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/my_level/domain/repositories/level_repository_interface.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class LevelRepository implements LevelRepositoryInterface{
  ApiClient apiClient;
  LevelRepository({required this.apiClient});

  @override
  Future<Response> getProfileLevelInfo() async{
    return apiClient.getData(AppConstants.getProfileLevel);
  }

}