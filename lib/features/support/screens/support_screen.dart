import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/support/controllers/help_support_controller.dart';
import 'package:ride_sharing_user_app/features/support/widgets/contact_us_view.dart';
import 'package:ride_sharing_user_app/features/support/widgets/help_support_type_button_widget.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';

class HelpAndSupportScreen extends StatefulWidget {
  const HelpAndSupportScreen({super.key});

  @override
  State<HelpAndSupportScreen> createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {
  late TabController tabController;
  late int currentPage;
  String data = '';

  @override
  void initState() {
    Get.find<HelpSupportController>().updateCurrentTabIndex(0);
    super.initState();
    data = '${Get.find<ConfigController>().config!.termsAndConditions?.shortDescription ?? ''}'
        '\n${Get.find<ConfigController>().config!.termsAndConditions?.longDescription ?? ''}';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (res,val){
            if(Get.find<HelpSupportController>().currentTabIndex == 1){
              Get.find<HelpSupportController>().updateCurrentTabIndex(0,isUpdate: true);
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
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body:GetBuilder<HelpSupportController>(builder: (supportController){
            return Stack(children: [
              BodyWidget(
                  appBar: AppBarWidget(
                      title: 'do_you_need_help'.tr,centerTitle: true,showBackButton: true,
                    onBackPressed: (){
                      if(Get.find<HelpSupportController>().currentTabIndex == 1){
                        Get.find<HelpSupportController>().updateCurrentTabIndex(0,isUpdate: true);
                      }else{
                        Get.back();
                      }
                    },
                  ),
                  body: Column(children: [
                    const SizedBox(height: Dimensions.paddingSizeSignUp),

                    Expanded(
                        child: supportController.currentTabIndex == 0 ?
                        const ContactUsView() :
                        SingleChildScrollView(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall).copyWith(top: Dimensions.paddingSizeExtraLarge),
                          physics: const BouncingScrollPhysics(),
                          child: HtmlWidget(data, key: const Key('terms_and_condition')),
                        )
                    ),
                  ]),
              ),

              Positioned(top: Get.height * (GetPlatform.isIOS ? 0.15 :  0.11), left: Dimensions.paddingSizeSmall,
                child: SizedBox(height: Get.find<LocalizationController>().isLtr? 45 : 50,
                  width: Get.width-Dimensions.paddingSizeDefault,
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    itemCount: supportController.helpAndSupportTabs.length,
                    itemBuilder: (context, index){
                      return SizedBox(width: Get.width/2.1, child: HelpSupportTypeButtonWidget(
                        profileTypeName : supportController.helpAndSupportTabs[index], index: index,
                      ));

                    },
                  ),
                ),
              ),
            ]);
          })
        ),
      ),
    );
  }
}
