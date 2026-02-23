import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';



class NoDataWidget extends StatelessWidget {
  final String? title;
  const NoDataWidget({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
            Image.asset(title == 'no_transaction_found' ? Images.noTransation
                : title == "no_point_gain_yet" ? Images.noPoint
                : title == "no_trip_found" ? Images.noTrip
                : title == "no_notification_found" ? Images.noNotificaiton
                : title == "no_message_found" ? Images.noMessage
                : title == "no_coupon_found" ? Images.noCopun
                : title == "no_chat_found" ? Images.noMessage
                : title == "no_address_found" ? Images.noLocation
                : Images.noDataFound, width: title == "no_notification_found" ? 70 :  100, height: title == "no_notification_found" ? 70 : 100,),

            Text(title != null ? title!.tr : 'no_data_found'.tr,
                style: textRegular.copyWith( color: Theme.of(context).hintColor,
                fontSize: Dimensions.fontSizeDefault), textAlign: TextAlign.center)])));
  }
}
