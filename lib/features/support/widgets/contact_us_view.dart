import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/svg_image_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsView extends StatelessWidget {
  const ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),

        Center(
          child: FutureBuilder<String>(
              future: loadSvgAndChangeColors(Images.helpAndSupportGraphics, Theme.of(context).primaryColor),
              builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  return SvgPicture.string(
                      snapshot.data!
                  );
                }
                return SvgPicture.asset(Images.helpAndSupportGraphics);
              }
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),

        Text(
          'we_love_to_hear_from_you'.tr,
          style: textBold,
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        InkWell(
          onTap: () async{
            await launchUrl(
              Uri(scheme: 'tel', path: Get.find<ConfigController>().config!.businessContactPhone!),
              mode: LaunchMode.externalApplication,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.2), blurRadius: 6, offset: Offset(0, 1))],
            ),
            padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('call_our_customer_support'.tr, style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [
                  Image.asset(Images.call, color: Theme.of(context).primaryColor, height: 14, width: 14),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Text(Get.find<ConfigController>().config!.businessContactPhone ?? '', style: textMedium.copyWith(color: Theme.of(context).primaryColor))
                ]),

                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                    boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.1), blurRadius: 6, offset: Offset(0, 1))],
                  ),
                  padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Image.asset(Images.callNewIcon, height: 16, width: 16),
                )
              ])
            ]),
          )
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        InkWell(
            onTap: () async{
              await launchUrl(
                Uri(scheme: 'mailto', path: Get.find<ConfigController>().config!.businessContactEmail!),
                mode: LaunchMode.externalApplication,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                color: Theme.of(context).cardColor,
                boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.2), blurRadius: 6, offset: Offset(0, 1))],
              ),
              padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('email_us_anytime'.tr, style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Row(children: [
                    Icon(Icons.email, color: Theme.of(context).primaryColor, size: 14),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Text(Get.find<ConfigController>().config!.businessContactEmail ?? '', style: textMedium.copyWith(color: Theme.of(context).primaryColor))
                  ]),

                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                      boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.1), blurRadius: 6, offset: Offset(0, 1))],
                    ),
                    padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Image.asset(Images.gmailIcon, height: 16, width: 16),
                  )
                ])
              ]),
            )
        ),

      ]),
    );
  }
}