import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/splash/domain/models/config_model.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> with WidgetsBindingObserver{

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Get.find<ConfigController>().getConfigData().then((bool isSuccess) {
        if(isSuccess){
          if(Get.find<ConfigController>().config!.maintenanceMode != null &&
              Get.find<ConfigController>().config!.maintenanceMode!.maintenanceStatus == 0){
            Get.offAll(()=> const DashboardScreen());
          }else if(Get.find<ConfigController>().config!.maintenanceMode != null &&
              Get.find<ConfigController>().config!.maintenanceMode!.maintenanceStatus == 1 &&
              Get.find<ConfigController>().config!.maintenanceMode!.selectedMaintenanceSystem!.userApp == 0) {
            Get.offAll(()=> const DashboardScreen());
          }
        }
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ConfigModel? configModel = Get.find<ConfigController>().config;
    return Scaffold(
      body: Center(
        child: Container(
          width: Dimensions.webMaxWidth,
          color: Theme.of(context).cardColor,
          padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.025),
          child: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

              SvgPicture.asset(Images.maintenanceSvg, width: 200, height: 200),
              SizedBox(height: size.height * 0.07),

              if(configModel != null) ... [

                if(configModel.maintenanceMode?.maintenanceMessages?.maintenanceMessage != null && configModel.maintenanceMode!.maintenanceMessages!.maintenanceMessage!.isNotEmpty)...[
                  Text(configModel.maintenanceMode?.maintenanceMessages?.maintenanceMessage ?? "",
                    textAlign: TextAlign.center,
                    style: textMedium.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                ],

                if(configModel.maintenanceMode?.maintenanceMessages?.messageBody != null && configModel.maintenanceMode!.maintenanceMessages!.messageBody!.isNotEmpty)...[
                  Text(configModel.maintenanceMode?.maintenanceMessages?.messageBody ?? "",
                    textAlign: TextAlign.center,
                    style: textMedium.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.5)
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                ],

                if(configModel.maintenanceMode?.maintenanceMessages?.businessEmail == 1 ||
                    configModel.maintenanceMode?.maintenanceMessages?.businessNumber == 1) ...[

                  if( (configModel.maintenanceMode?.maintenanceMessages?.maintenanceMessage != null && configModel.maintenanceMode!.maintenanceMessages!.maintenanceMessage!.isNotEmpty) ||
                      (configModel.maintenanceMode?.maintenanceMessages?.messageBody != null && configModel.maintenanceMode!.maintenanceMessages!.messageBody!.isNotEmpty)) ...[

                    Row(
                      children: List.generate(size.width ~/10, (index) => Expanded(
                        child: Container(
                          color: index%2==0?Colors.transparent
                              :Theme.of(context).hintColor.withValues(alpha:0.2),
                          height: 2,
                        ),
                      )),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                  ],

                  Text('any_query_feel_free_to_call'.tr,
                    style: textRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  if(configModel.maintenanceMode?.maintenanceMessages?.businessNumber == 1)...[
                    InkWell(
                      onTap: (){
                        launchUrl(Uri.parse(
                          'tel:${configModel.businessSupportPhone}',
                        ), mode: LaunchMode.externalApplication);
                      },
                      child: Text(configModel.businessSupportPhone ?? "",
                        style: textRegular.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.5),
                          fontSize: Dimensions.fontSizeDefault,
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  ],

                  if(configModel.maintenanceMode?.maintenanceMessages?.businessEmail == 1)
                    InkWell(
                      onTap: (){
                        launchUrl(Uri.parse(
                          'mailto:${configModel.businessSupportEmail}',
                        ), mode: LaunchMode.externalApplication);
                      },

                      child: Text(configModel.businessSupportEmail ?? "",
                        style: textRegular.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.5),
                          fontSize: Dimensions.fontSizeDefault,
                        ),
                      ),
                    ),

                ]

              ],

            ]),
          ),
        ),
      ),
    );
  }
}
