import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/auth/widgets/test_field_title.dart';
import 'package:ride_sharing_user_app/features/location/view/access_location_screen.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/custom_text_field.dart';

class EditProfileAccountInfo extends StatefulWidget {
  final bool fromAccount;
  const EditProfileAccountInfo({super.key,  this.fromAccount = false});

  @override
  State<EditProfileAccountInfo> createState() => _EditProfileAccountInfoState();
}

class _EditProfileAccountInfoState extends State<EditProfileAccountInfo> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController idNumberController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + Get.height*0.3,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }


  @override
  void initState() {
    super.initState();

    firstNameController.text = Get.find<ProfileController>().profileModel!.data!.firstName ?? '';
    lastNameController.text = Get.find<ProfileController>().profileModel!.data!.lastName ?? '';
    phoneController.text = Get.find<ProfileController>().profileModel!.data!.phone!;
    idNumberController.text = Get.find<ProfileController>().profileModel!.data!.identificationNumber ?? '';
    if(Get.find<ProfileController>().profileModel!.data != null) {
      Get.find<ProfileController>().setIdentityType(Get.find<ProfileController>().profileModel!.data!.identificationType ?? '', notify: false);
    }else {
      Get.find<ProfileController>().setIdentityType(Get.find<ProfileController>().identityTypeList[0], notify: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (profileController) {
      return Column(children: [
        Expanded(child: SingleChildScrollView( controller: _scrollController,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TextFieldTitle(title: 'first_name'.tr,textOpacity: 0.8),

            CustomTextField(
              prefixIcon: Images.editProfileName,
              borderRadius: 10,
              capitalization: TextCapitalization.words,
              showBorder: true,
              controller: firstNameController,
              hintText: 'enter_first_name'.tr,
              fillColor: Theme.of(context).primaryColor.withValues(alpha:0.04),
            ),

            TextFieldTitle(title: 'last_name'.tr,textOpacity: 0.8),

            CustomTextField(
              prefixIcon: Images.editProfileName,
              borderRadius: 10,
              capitalization: TextCapitalization.words,
              showBorder: false,
              controller: lastNameController,
              hintText: 'enter_last_name'.tr,
              fillColor: Theme.of(context).primaryColor.withValues(alpha:0.04),
            ),

            TextFieldTitle(title: 'phone'.tr,textOpacity: 0.8),

            CustomTextField(
              isEnabled: false,
              prefixIcon: Images.editProfilePhone,
              borderRadius: 10,
              controller: phoneController,
              textColor: Theme.of(context).hintColor,
              showBorder: false,
              hintText: 'enter_your_phone'.tr,
              fillColor: Theme.of(context).hintColor.withValues(alpha:.15),
            ),

            TextFieldTitle(title: 'identity_type'.tr,textOpacity: 0.8),

            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 0.5, color: Theme.of(context).hintColor.withValues(alpha:0.7)),
              ),
              child: DropdownButton<String>(
                hint: profileController.identityType.tr.isEmpty ?
                Text('select_identity_type'.tr) :
                Text(
                  profileController.identityType.tr,
                  style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
                ),
                items: profileController.identityTypeList.map((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(
                      value.tr,style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color)
                  ));
                }).toList(),
                onChanged: (val) => profileController.setIdentityType(val!),
                isExpanded: true,
                underline: const SizedBox(),
                value: profileController.identityType,
              ),
            ),

            TextFieldTitle(title: 'identification_number'.tr,textOpacity: 0.8),

            CustomTextField(
              prefixIcon: Images.editProfileIdentity,
              borderRadius: 10,
              controller:  idNumberController,
              showBorder: false,
              hintText: 'enter_your_identification_number'.tr,
              fillColor: Theme.of(context).primaryColor.withValues(alpha:0.04),
            ),

            if(profileController.profileModel!.data!.identificationImage!.isNotEmpty)
              Padding(
                padding:  const EdgeInsets.fromLTRB(
                  Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeDefault,0
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount : profileController.profileModel?.data?.identificationImage?.length ,
                  itemBuilder: (BuildContext context, index){
                    return Padding(
                      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                      child: DottedBorder(
                        options: RoundedRectDottedBorderOptions(
                          dashPattern: const [10, 5],
                          strokeWidth: 2,
                          color: Theme.of(context).hintColor,
                          radius: const Radius.circular(Dimensions.paddingSizeSmall)
                        ),
                        child: Stack(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.width/4.3,
                              width: MediaQuery.of(context).size.width,
                              child: ImageWidget(
                                  image: "${Get.find<ConfigController>().config?.imageBaseUrl?.identityImage}/${profileController.profileModel?.data?.identificationImage?[index]??''}"),
                            ),
                          ),

                          Positioned(
                            bottom: 0, right: 0, top: 0, left: 0,
                            child: Container(decoration: BoxDecoration(
                              color: Theme.of(context).hintColor.withValues(alpha:0.07),
                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                            )),
                          ),
                        ]),
                      ),
                    );
                  } ,
                ),
              ),

            Padding(
              padding:  const EdgeInsets.fromLTRB(
                Dimensions.paddingSizeDefault, 0,
                Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault,
              ),
              child: ListView.builder(
                padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount : profileController.identityImages.length>= 2 ? 2: profileController.identityImages.length + 1 ,
                itemBuilder: (BuildContext context, index){
                  return index ==  profileController.identityImages.length ?
                  InkWell(
                    onTap: () async {
                      bool res = await profileController.pickImage(false, false,);
                      if(res){
                        _scrollDown();
                      }
                    },
                    child: DottedBorder(
                      options: RoundedRectDottedBorderOptions(
                        strokeWidth: 2,
                        dashPattern: const [10,5],
                        color: Theme.of(context).hintColor,
                        radius: const Radius.circular(Dimensions.paddingSizeSmall),
                      ),
                      child: Stack(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.width/4.3,
                            width: MediaQuery.of(context).size.width,
                            child: Image.asset(Images.cameraPlaceholder, scale: 3),
                          ),
                        ),

                        Positioned(
                          bottom: 0, right: 0, top: 0, left: 0,
                          child: Container(decoration: BoxDecoration(
                            color: Theme.of(context).hintColor.withValues(alpha:0.07),
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                          )),
                        ),
                      ]),
                    ),
                  ) :
                  Stack(children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),
                          child:  Image.file(
                            File(profileController.identityImages[index].path),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width/4.3,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      top:0,right:0,
                      child: InkWell(onTap :() => profileController.removeImage(index),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault)),
                          ),
                          child: const Padding(padding: EdgeInsets.all(4.0),
                            child: Icon(Icons.delete_forever_rounded,color: Colors.red,size: 15),
                          ),
                        ),
                      ),
                    ),
                  ]);
                },
              ),
            ),
          ]),
        )),
        const SizedBox(height: 30),

        profileController.isUpdating ?
        Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0)) :
        ButtonWidget (
          buttonText:"update_profile".tr,
          onPressed: () async {
            if(idNumberController.text.isEmpty || idNumberController.text.length < 6 || idNumberController.text.length> 50){
              showCustomSnackBar('identity_number_is_invalid'.tr, isError: true);
            }else{
              Response response = await profileController.updateProfile(
                firstNameController.text, lastNameController.text, profileController.identityType, idNumberController.text,
              );
              if(response.statusCode == 200) {
                showCustomSnackBar('profile_updated_successfully'.tr, isError: false);
                if(widget.fromAccount){
                  Get.offAll(() => const AccessLocationScreen());
                }
              }
            }
          },
        ),

      ]);
    });
  }
}