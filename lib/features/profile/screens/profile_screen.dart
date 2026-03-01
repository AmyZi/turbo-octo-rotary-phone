import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/confirmation_bottomsheet_widget.dart';
import 'package:ride_sharing_user_app/features/address/screens/my_address.dart';
import 'package:ride_sharing_user_app/features/message/screens/message_list.dart';
import 'package:ride_sharing_user_app/features/my_level/screens/my_level_screen.dart';
import 'package:ride_sharing_user_app/features/my_offer/screens/my_offer_screen.dart';
import 'package:ride_sharing_user_app/features/profile/widgets/profile_item.dart';
import 'package:ride_sharing_user_app/features/refer_and_earn/screens/refer_and_earn_screen.dart';
import 'package:ride_sharing_user_app/features/safety_setup/screens/safety_setup_screen.dart';
import 'package:ride_sharing_user_app/features/settings/domain/html_enum_types.dart';
import 'package:ride_sharing_user_app/features/settings/screens/setting_screen.dart';
import 'package:ride_sharing_user_app/features/support/screens/support_screen.dart';
import 'package:ride_sharing_user_app/features/trip/screens/trip_screen.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/settings/screens/policy_screen.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/profile/screens/edit_profile_screen.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/screens/wallet_screen.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: GetBuilder<ProfileController>(builder: (profileController) {
          return BodyWidget(appBar: AppBarWidget(title: 'profile'.tr,showBackButton: false),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(children:  [
                Stack(clipBehavior: Clip.none, children: [
                  Container(height: 175, width: Get.width,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                      color:Get.isDarkMode ? Theme.of(context).scaffoldBackgroundColor :
                      Theme.of(context).primaryColor.withValues(alpha:0.1),
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                        child: Row( children: [
                          Container(
                            decoration: BoxDecoration(shape: BoxShape.circle,
                              border: Border.all(color: Theme.of(context).primaryColor, width: 1),
                            ),
                            child: ClipRRect(borderRadius: BorderRadius.circular(50),
                              child: ImageWidget(height: 70, width: 70,
                                image: profileController.profileModel?.data?.profileImage != null ?
                                '${Get.find<ConfigController>().config!.imageBaseUrl!.profileImage}/'
                                    '${profileController.profileModel?.data?.profileImage??''}' :
                                '',
                                placeholder: Images.personPlaceholder, fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          const SizedBox(width: Dimensions.paddingSizeSmall),
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            SizedBox(width: Get.width * 0.5,
                              child: Text(profileController.customerName(),
                                style: textBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge,color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.9)),
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                            if(Get.find<ConfigController>().config?.levelStatus ?? false)
                            Row(children: [
                              Text("${'level'.tr} : ${ profileController.profileModel?.data?.level?.name??'0'}",
                                style: textBold.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8),
                                  fontSize: Dimensions.fontSizeSmall,
                                ),
                              ),

                              const SizedBox(width: 5),
                              SizedBox(width: 15, height : 15,
                                child: ImageWidget(
                                  image: "${AppConstants.baseUrl}/storage/app/public/customer/level/"
                                      "${profileController.profileModel!.data!.level?.image}",
                                ),
                              )
                            ]),

                            Row(children: [
                              Text('${"your_rating".tr} :'.tr,
                                style: textBold.copyWith(
                                  color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8), fontSize: Dimensions.fontSizeSmall,
                                ),
                              ),

                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                              Text(profileController.profileModel!.data!.userRating?? "0",
                                style: textBold.copyWith(fontSize: Dimensions.fontSizeSmall,
                                  letterSpacing: 3, color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8),
                                ),
                              ),
                              const Icon(Icons.star,size: 12,color: Colors.amber),
                            ]),
                          ]),
                        ]),
                      ),

                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                        _buildColumnItem('total_ride','${profileController.profileModel?.data?.totalRideCount??0}',
                          context,
                        ),

                        Container(width: 1,height: 40,color: Theme.of(context).primaryColor),

                        _buildColumnItem('total_point','${profileController.profileModel?.data?.loyaltyPoints??0}',
                          context,
                        ),
                      ]),
                    ]),
                  ),

                  Positioned(child: Align(alignment: Alignment.topRight, child: InkWell(
                    onTap: () => Get.to(() => const EditProfileScreen()),
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: SizedBox(width: 20,child: Image.asset(Images.editIcon)),
                    ),
                  )))

                ]),

                ProfileMenuItem(title: 'profile', icon: Images.profileProfile,
                  onTap: () => Get.to(() => const EditProfileScreen()),
                ),

                ProfileMenuItem(title: 'my_address', icon: Images.location,
                  onTap: () => Get.to(() => const MyAddressScreen()),
                ),

                ProfileMenuItem(title: 'message', icon: Images.profileMessage,
                  onTap: () => Get.to(() => const MessageListScreen()),
                ),

                ProfileMenuItem(title: 'my_wallet', icon: Images.profileMyWallet,
                  onTap: () => Get.to(() => const WalletScreen()),
                ),

                ProfileMenuItem(title: 'my_offer', icon: Images.paymentAndVoucher,
                  onTap: () => Get.to(() => MyOfferScreen()),
                ),

                ProfileMenuItem(title: 'my_trips', icon: Images.profileMyTrip,
                  onTap: () => Get.to(() => const TripScreen(fromProfile: true)),
                ),

                ProfileMenuItem(title: 'safety', icon: Images.privacyPolicy,
                  onTap: () => Get.to(() => const SafetySetupScreen()),
                ),

                if((Get.find<ConfigController>().config?.referralEarningStatus ?? false) ||
                    ((Get.find<ProfileController>().profileModel?.data?.wallet?.referralEarn ?? 0) > 0))
                ProfileMenuItem(title: 'refer_and_earn', icon: Images.referralIcon1,
                  onTap: () => Get.to(() => const ReferAndEarnScreen()),
                ),

                if(Get.find<ConfigController>().config?.levelStatus ?? false)
                ProfileMenuItem(title: 'my_level', icon: Images.myLevelIcon,
                  onTap: () => Get.to(() => const MyLevelScreen()),
                ),

                ProfileMenuItem(title: 'help_support', icon: Images.profileHelpSupport,
                  onTap: () => Get.to(() => const HelpAndSupportScreen()),
                ),

                ProfileMenuItem(title: 'settings', icon: Images.profileSetting,
                  onTap: () => Get.to(() => const SettingScreen()),
                ),

                ProfileMenuItem(title: 'privacy_policy', icon: Images.privacyPolicyIcon,
                  onTap: () => Get.to(() =>  PolicyScreen(htmlType: HtmlType.privacyPolicy,
                    image: Get.find<ConfigController>().config?.privacyPolicy?.image??'',
                  )),
                ),

                ProfileMenuItem(title: 'refund_policy', icon: Images.privacyPolicyIcon,
                  onTap: () => Get.to(() =>  PolicyScreen(htmlType: HtmlType.refundPolicy,
                    image: Get.find<ConfigController>().config?.refundPolicy?.image??'',
                  )),
                ),

                ProfileMenuItem(title: 'terms_and_condition', icon: Images.termsAndCondition,
                  onTap: () => Get.to(() =>  PolicyScreen(htmlType: HtmlType.termsAndConditions,
                    image: Get.find<ConfigController>().config?.termsAndConditions?.image??'',
                  )),
                ),

                ProfileMenuItem(title: 'legal', icon: Images.privacyPolicy,
                  onTap: () => Get.to(() =>  PolicyScreen(htmlType: HtmlType.legal,
                    image: Get.find<ConfigController>().config?.legal?.image??'',
                  )),
                ),

                ProfileMenuItem(title: 'logout', icon: Images.profileLogout,
                  onTap: () {
                    Get.bottomSheet(
                      GetBuilder<AuthController>(builder: (authController){
                        return ConfirmationBottomsheetWidget(
                          icon: Images.exitIcon,
                          title: 'Logout'.tr,
                          description: 'do_you_want_to_log_out_this_account'.tr,
                          iconColor: Theme.of(context).cardColor,
                          isLoading: authController.isLoading,
                          onYesPressed: (){
                            Get.find<AuthController>().logOut();
                          },
                          onNoPressed: ()=> Get.back(),
                        );
                      })
                    );
                  },
                ),

                ProfileMenuItem(title: 'permanently_delete_account'.tr,
                  icon: Images.deleteAccountIcon,
                  divider: false,
                  onTap: () {
                    Get.bottomSheet(
                      GetBuilder<AuthController>(builder: (authController){
                        return ConfirmationBottomsheetWidget(
                          icon: Images.exitIcon,
                          title: 'delete_account'.tr,
                          description: 'are_you_sure_permanent_delete_smg'.tr,
                          iconColor: Theme.of(context).cardColor,
                          isLoading: authController.isLoading,
                          onYesPressed: (){
                            Get.find<AuthController>().permanentlyDelete();
                          },
                          onNoPressed: ()=> Get.back(),
                        );
                      })
                    );

                  },
                ),

                const SizedBox(height: Dimensions.paddingSizeExtraLarge * 4),

              ]),
            ),
          );
        }),
      ),
    );
  }

  Column _buildColumnItem(String title,String value,BuildContext context) {
    return Column(children: [
      Text(value,style: textBold.copyWith(color: Theme.of(context).primaryColor,
        fontSize: Dimensions.fontSizeExtraLarge,
      )),

      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
      Text(title.tr,style: textMedium.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8))),
    ]);
  }

}




