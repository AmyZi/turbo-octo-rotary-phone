
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/profile/domain/repositories/profile_repository_interface.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class ProfileRepository implements ProfileRepositoryInterface{
  final ApiClient apiClient;
  ProfileRepository({required this.apiClient});

  @override
  Future<Response?> getProfileInfo() async {
    return await apiClient.getData(AppConstants.profileInfo);
  }

  @override
  Future<Response?> updateProfileInfo(String firstName, String lastname, String identification, String idType, XFile? profile, List<MultipartBody>? identityImage) async {
    Map<String, String> fields = <String, String> {
      '_method': 'put',
      'first_name': firstName,
      'last_name': lastname,
      "identification_number" : identification,
      "identification_type" : idType
    };
    List<MultipartBody> multipartList = [];
    for(int i =0; i< Get.find<ProfileController>().identityImages.length; i++){
      multipartList.add(MultipartBody('identity_images[$i]', Get.find<ProfileController>().identityImages[i]));
    }

    return await apiClient.postMultipartData(
      AppConstants.updateProfileInfo,
      fields, MultipartBody('profile_image',profile), multipartList
    );
  }

}