import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/parcel_info_widget.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';

class SenderReceiverInfoWidget extends StatefulWidget {
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  const SenderReceiverInfoWidget({super.key, required this.expandableKey});

  @override
  State<SenderReceiverInfoWidget> createState() => _SenderReceiverInfoWidgetState();
}
class _SenderReceiverInfoWidgetState extends State<SenderReceiverInfoWidget> {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: GetBuilder<ParcelController>(builder: (parcelController) {
        return Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: MediaQuery.of(context).size.width * 0.7, height: 45,
            decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault + 2),),
            child: TabBar(padding: EdgeInsets.zero,
              dividerHeight: 0,
              indicatorSize: TabBarIndicatorSize.tab,
              controller: parcelController.tabController,
              unselectedLabelColor: Colors.grey,
              labelColor:  Colors.white,
              labelStyle: textMedium.copyWith(),
              indicatorColor: Theme.of(context).primaryColor,
              indicator:  BoxDecoration(color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
              tabs:  [
                SizedBox(height: 30, child: Tab(text: 'sender_info'.tr,)),
                SizedBox(height: 30, child: Tab(text: 'receiver_info'.tr)),
              ],
              onTap: (index) {
                parcelController.updateTabControllerIndex(index);

                if(index != 0) {
                  if(parcelController.getReceiverCountryDialCode == null) {
                    parcelController.onChangeReceiverCountryCode(parcelController.getSenderCountryCode);
                  }
                }

              },
            ),
          ),

          ParcelInfoWidget(isSender: parcelController.tabController.index == 0, expandableKey: widget.expandableKey),

        ]);
      }),
    );
  }

}
