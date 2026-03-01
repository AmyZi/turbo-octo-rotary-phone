import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/profile/widgets/edit_profile_account_info.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/dashboard/controllers/bottom_menu_controller.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';

class EditProfileScreen extends StatefulWidget {
  final bool fromLogin;
  const EditProfileScreen({super.key,  this.fromLogin = false});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  void onBackPressed() {
    if(widget.fromLogin) {
      Get.find<BottomMenuController>().exitApp();
    }
  }
  @override
  void initState() {
    Get.find<ProfileController>().identityImages.clear();
    Get.find<ProfileController>().clearSelectedImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: BodyWidget(
          appBar: AppBarWidget(title: 'profile_info', showBackButton: true, onBackPressed: () {
            if(widget.fromLogin) {
              onBackPressed();
            }else{
              Get.back();
            }
          }),
          body: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
            child: Column(children:  [
              GetBuilder<ProfileController>(builder: (profileController) {
                return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  InkWell(
                    onTap:() => profileController.pickImage(false, true),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Theme.of(context).primaryColor,width: 2),
                      ),
                      child: Stack(clipBehavior: Clip.none, children: [
                        profileController.pickedProfileFile == null ?
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: ImageWidget(height: 70, width: 70,
                            image: profileController.profileModel?.data?.profileImage != null?
                            '${Get.find<ConfigController>().config!.imageBaseUrl!.profileImage!}/'
                                '${profileController.profileModel?.data?.profileImage??''}':'',
                            placeholder: Images.personPlaceholder, fit: BoxFit.cover,
                          ),
                        ) :
                        CircleAvatar(radius: 35,
                          backgroundColor: Theme.of(context).hintColor.withValues(alpha:0.50),
                          backgroundImage:FileImage(File(profileController.pickedProfileFile!.path)),
                        ),

                        Positioned(right: 5, bottom: -3,
                          child: Container(
                            decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                            padding: const EdgeInsets.all(5),
                            child: const Icon(Icons.camera_enhance_rounded, color: Colors.white,size: 13),
                          ),
                        )
                      ]),
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeDefault),

                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      profileController.customerName(),
                      style: textBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.paddingSizeExtraSmall
                      ).copyWith(right: Dimensions.paddingSizeExtraSmall),
                      child: Text(
                        profileController.profileModel!.data!.level!.name!,
                        style: textBold.copyWith(color: Theme.of(context).hintColor,fontSize: Dimensions.fontSizeSmall),
                      ),
                    ),

                    Row(children: [
                      Text(
                        '${"your_rating".tr} :'.tr,
                        style: textBold.copyWith(color: Theme.of(context).hintColor,fontSize: Dimensions.fontSizeSmall),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      Text(
                        profileController.profileModel!.data!.userRating ?? "0",
                        style: textBold.copyWith(
                          fontSize: Dimensions.fontSizeSmall, letterSpacing: 3,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      const Icon(Icons.star,size: 12,color: Colors.amber),
                    ]),

                  ])),
                ]);
              }),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),

              Expanded(child: EditProfileAccountInfo(fromAccount: widget.fromLogin)),

            ]),
          ),
        ),
      ),
    );
  }
}




