import 'dart:async';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/profile/domain/models/profile_model.dart';
import 'package:ride_sharing_user_app/features/profile/domain/services/profile_service_interface.dart';
import 'package:ride_sharing_user_app/helper/file_validation_helper.dart';

class ProfileController extends GetxController implements GetxService {
  final ProfileServiceInterface profileServiceInterface;
  ProfileController({required this.profileServiceInterface});

  final List<String> _identityTypeList = ['passport', 'driving_license', 'nid'];
  XFile? _pickedProfileFile;
  List<MultipartBody> multipartList = [];
  XFile? _pickedIdentityImageFront;
  XFile identityImage = XFile('');
  XFile? _pickedIdentityImageBack;
  bool isLoading = false;
  String _identityType = '';
  ProfileModel? profileModel;
  bool isUpdating = false;

  XFile? get pickedProfileFile => _pickedProfileFile;
  XFile? get pickedIdentityImageFront => _pickedIdentityImageFront;
  XFile? get pickedIdentityImageBack => _pickedIdentityImageBack;
  List<XFile> identityImages = [];
  List<String> get identityTypeList => _identityTypeList;
  String get identityType => _identityType;

  void setIdentityType (String setValue, {bool notify = true}) {
    if(setValue.isEmpty) {
      _identityType = _identityTypeList[0];
    }else {
      _identityType = setValue;
    }
    if(notify) {
      update();
    }
  }

  Future<bool> pickImage(bool isBack, bool isProfile) async {
     if(isProfile){
      _pickedProfileFile = (await FileValidationHelper.validateAndPickImage(source: ImageSource.gallery))!;

    } else{
       identityImage = (await FileValidationHelper.validateAndPickImage(source: ImageSource.gallery))!;
      identityImages.add(identityImage);
    }
     update();
     return true;
  }

  void removeImage(int index){
    identityImages.removeAt(index);
    update();
  }

  void clearSelectedImage(){
    _pickedProfileFile = null;
  }

  String customerName() {
    if(profileModel != null) {
      return '${profileModel!.data!.firstName ?? ''} ${profileModel!.data!.lastName ?? ''}';
    }else {
      return 'Guest';
    }
  }

  String customerFirstName() {
    if(profileModel != null) {
      return profileModel!.data!.firstName ?? '';
    }else {
      return 'Guest';
    }
  }

  Future<Response> getProfileInfo() async {
    Response? response = await profileServiceInterface.getProfileInfo();
    if(response!.statusCode == 200) {
      profileModel = ProfileModel.fromJson(response.body);
    }else{
      ApiChecker.checkApi(response);
    }
    isLoading = false;
    update();
    return response;
  }

  Future<Response> updateProfile( String firstName, String lastName,String identityType,String idNumber) async {
    isUpdating = true;
    update();
    Response? response = await profileServiceInterface.updateProfileInfo(
      firstName, lastName, idNumber, identityType, _pickedProfileFile, multipartList,
    );
    if(response!.statusCode == 200){
      Get.back();
      getProfileInfo();
    }else{
      ApiChecker.checkApi(response);
    }
    isUpdating = false;
    update();
    return response;
  }

}