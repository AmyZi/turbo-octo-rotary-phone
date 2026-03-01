import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';
import 'package:ride_sharing_user_app/features/home/widgets/banner_shimmer.dart';
import 'package:ride_sharing_user_app/features/safety_setup/controllers/safety_alert_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class SafetySetupScreen extends StatefulWidget {
  const SafetySetupScreen({super.key});

  @override
  State<SafetySetupScreen> createState() => _SafetySetupScreenState();
}

class _SafetySetupScreenState extends State<SafetySetupScreen> {

  @override
  void initState() {
    Get.find<SafetyAlertController>().getPrecautionList();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: BodyWidget(
          appBar: AppBarWidget(title: 'safety'.tr, showBackButton: true,centerTitle: true),
          body: GetBuilder<SafetyAlertController>(builder: (safetyAlertController){
            return Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(spacing: Dimensions.paddingSizeSmall,crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(width: Get.width,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
                  ),
                  child: Column(spacing: Dimensions.paddingSizeSmall, children: [
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Image.asset(Images.safelyShieldIcon1,height: 80,width: 80),

                    Text('trip_safety'.tr,style: textSemiBold.copyWith(fontSize: 16)),

                    Padding(
                      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall,left: Dimensions.paddingSizeSmall,right: Dimensions.paddingSizeSmall),
                      child: Text('when_you_make_a_call_or_send_ext'.tr,style: textRegular.copyWith(fontSize: 10),textAlign: TextAlign.center),
                    )

                  ]),
                ),

                Text('safety_precautions'.tr,style: textSemiBold),

                Flexible(
                  child: safetyAlertController.precautionListModel != null ?
                  ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: safetyAlertController.precautionListModel?.data?.length ?? 0,
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                          border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2))
                        ),
                        child: ExpansionTile(
                          collapsedIconColor: Theme.of(context).textTheme.bodyMedium!.color,
                          iconColor: Theme.of(context).textTheme.bodyMedium!.color,
                          title: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('${index+1}.',style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color)),

                            Flexible(child: Text(
                              '${safetyAlertController.precautionListModel?.data?[index].title}',
                              style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color),
                            )),
                          ]),
                          shape: Border(),
                          expandedAlignment: Alignment.centerLeft,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall,horizontal: Dimensions.paddingSizeExtraLarge),
                              child: Text('${safetyAlertController.precautionListModel?.data?[index].description}'),
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context,index){
                      return SizedBox(height: Dimensions.paddingSizeSmall);
                    },
                  ) :
                  const BannerShimmer(),
                )
              ]),
            );
          }),
        ),
      ),
    );
  }
}
