import 'package:image_picker/image_picker.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/profile/domain/repositories/profile_repository_interface.dart';
import 'package:ride_sharing_user_app/features/profile/domain/services/profile_service_interface.dart';

class ProfileService implements ProfileServiceInterface{
  ProfileRepositoryInterface profileRepositoryInterface;
  ProfileService({required this.profileRepositoryInterface});

  @override
  Future getProfileInfo() async {
    return await profileRepositoryInterface.getProfileInfo();
  }

  @override
  Future updateProfileInfo(String firstName, String lastname, String identification, String idType, XFile? profile, List<MultipartBody>? identityImage) async{
    return await profileRepositoryInterface.updateProfileInfo(firstName, lastname, identification, idType, profile, identityImage);
  }

}