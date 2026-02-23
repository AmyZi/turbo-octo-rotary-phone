import 'package:image_picker/image_picker.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';

abstract class ProfileServiceInterface{
  Future<dynamic> getProfileInfo();
  Future<dynamic> updateProfileInfo(String firstName, String lastname, String identification, String idType, XFile? profile, List<MultipartBody>? identityImage);

}