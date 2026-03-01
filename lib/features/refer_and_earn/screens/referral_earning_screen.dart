import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/no_data_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/paginated_list_widget.dart';
import 'package:ride_sharing_user_app/features/notification/widgets/notification_shimmer.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/refer_and_earn/controllers/refer_and_earn_controller.dart';
import 'package:ride_sharing_user_app/features/refer_and_earn/widgets/earning_cart_widget.dart';
import 'package:ride_sharing_user_app/features/wallet/widget/custom_title.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ReferralEarningScreen extends StatelessWidget {
  const ReferralEarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall,horizontal: Dimensions.paddingSizeDefault),
        child: GetBuilder<ReferAndEarnController>(builder: (referAndEarnController){
          return Column(children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                  color: Theme.of(context).highlightColor.withValues(alpha:0.1),
                  border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:0.1))
              ),
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('your_earning'.tr,style: textRegular.copyWith(color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.9) : null)),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Text(PriceConverter.convertPrice(Get.find<ProfileController>().profileModel?.data?.wallet?.referralEarn ?? 0),style: textRobotoBold.copyWith(color: Theme.of(context).primaryColor,fontSize: 20))
                ]),

                Image.asset(Images.loyaltyPoint,height: 40,width: 40)
              ]),
            ),

            CustomTitle(title: 'earning_history'.tr,color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8)),
            Divider(thickness: .25,color: Theme.of(context).primaryColor.withValues(alpha:0.25)),

            referAndEarnController.referralModel?.data != null ?
            (referAndEarnController.referralModel!.data!.isNotEmpty) ?
            Expanded(child: SingleChildScrollView(
              controller: referAndEarnController.scrollController,
              child: PaginatedListWidget(
                scrollController: referAndEarnController.scrollController,
                totalSize: referAndEarnController.referralModel!.totalSize,
                offset: (referAndEarnController.referralModel?.offset != null) ? int.parse(referAndEarnController.referralModel!.offset.toString()) : null,
                onPaginate: (int? offset) async {
                  await referAndEarnController.getEarningHistoryList(offset!);
                },
                itemView: ListView.builder(
                  itemCount: referAndEarnController.referralModel!.data!.length,
                  padding: const EdgeInsets.all(0),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return EarningCartWidget(transaction: referAndEarnController.referralModel!.data![index]);
                  },
                ),
              ),
            )) :
            const Expanded(child: NoDataWidget(title: 'no_transaction_found')) :
            const Expanded(child: NotificationShimmer()),

          ]);
        }),
      ),
    );
  }
}
