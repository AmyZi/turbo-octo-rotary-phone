import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';


class CategoryRepo{
  final ApiClient apiClient;

  CategoryRepo({required this.apiClient});

  Future<Response?> getCategoryList() async {
    return await apiClient.getData(AppConstants.vehicleMainCategory);
  }

}