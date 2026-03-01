import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/refer_and_earn/controllers/refer_and_earn_controller.dart';
import 'package:ride_sharing_user_app/features/refer_and_earn/screens/referral_details_screen.dart';
import 'package:ride_sharing_user_app/features/refer_and_earn/screens/referral_earning_screen.dart';
import 'package:ride_sharing_user_app/features/refer_and_earn/widgets/referral_type_button_widget.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';

class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({super.key});

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {

  @override
  void initState() {
    Get.find<ReferAndEarnController>().getEarningHistoryList(1);
    Get.find<ReferAndEarnController>().getReferralDetails();
    Get.find<ReferAndEarnController>().updateCurrentTabIndex(0);
    Get.find<ProfileController>().getProfileInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (res,val){
        if(Get.find<ReferAndEarnController>().currentTabIndex == 1){
          Get.find<ReferAndEarnController>().updateCurrentTabIndex(0,isUpdate: true);
        }else{
          if(!res){
            if(Navigator.canPop(context)){
              Get.back();
            }else{
              Get.offAll(()=> const DashboardScreen());
            }
          }
        }
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: GetBuilder<ReferAndEarnController>(builder: (referAndEarnController) {
            return Stack(children: [
              BodyWidget(
                  appBar: AppBarWidget(
                      title: 'refer_and_earn'.tr, centerTitle: true,
                    onBackPressed: (){
                      if(Get.find<ReferAndEarnController>().currentTabIndex == 1){
                        Get.find<ReferAndEarnController>().updateCurrentTabIndex(0,isUpdate: true);
                      }else {
                        Get.back();
                      }
                    },
                  ),
                  body: Column(children: [
                    const SizedBox(height: Dimensions.paddingSizeSignUp),

                    Expanded(
                        child: referAndEarnController.currentTabIndex == 0 ?
                        const ReferralDetailsScreen() :
                        const ReferralEarningScreen()
                    ),
                  ])
              ),

              Positioned(top: Get.height * (GetPlatform.isIOS ? 0.15 :  0.11), left: Dimensions.paddingSizeSmall,
                child: SizedBox(height: Get.find<LocalizationController>().isLtr? 45 : 50,
                  width: Get.width-Dimensions.paddingSizeDefault,
                  child: Center(
                    child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        itemCount: referAndEarnController.referAndEarnType.length,
                        itemBuilder: (context, index){
                          return SizedBox(width: Get.width/2.1, child: ReferralTypeButtonWidget(
                            profileTypeName : referAndEarnController.referAndEarnType[index], index: index,
                          ));
                        }
                    ),
                  ),
                ),
              ),
            ]);
          }),
        ),
      ),
    );
  }
}
