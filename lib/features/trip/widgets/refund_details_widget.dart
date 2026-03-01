import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';
import 'package:ride_sharing_user_app/features/auth/domain/enums/refund_status_enum.dart';
import 'package:ride_sharing_user_app/features/my_offer/screens/my_offer_screen.dart';
import 'package:ride_sharing_user_app/features/refund_request/screens/image_video_viewer.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/customer_note_view_widget.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';


class RefundDetailsWidget extends StatelessWidget {
  const RefundDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (rideController){
      return Column(children: [
        Row(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
            child: Text('refund_details'.tr, style: textSemiBold.copyWith(
              fontSize: Dimensions.fontSizeDefault,color: Theme.of(context).textTheme.bodyMedium?.color,
            )),
          ),
        ]),

        Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault)),
              border: Border.all(color: Theme.of(context).hintColor.withValues(alpha:0.2))
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha:0.07),
                borderRadius: const BorderRadius.only(topRight: Radius.circular(Dimensions.paddingSizeDefault),topLeft: Radius.circular(Dimensions.paddingSizeDefault)),
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  rideController.tripDetails?.parcelRefund?.status == RefundStatus.pending ?
                  'refund_request_send'.tr :
                  rideController.tripDetails?.parcelRefund?.status == RefundStatus.approved ?
                  'refund_request_approved'.tr :
                  rideController.tripDetails?.parcelRefund?.status == RefundStatus.denied ?
                  'refund_request_denied'.tr :
                  rideController.tripDetails?.parcelRefund?.refundMethod == 'coupon' ?
                  'refund_to_coupon'.tr :
                  rideController.tripDetails?.parcelRefund?.refundMethod == 'wallet' ?
                  'refund_to_wallet'.tr :
                  'refund_to_manually'.tr ,
                  style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),

                Text('ID# ${rideController.tripDetails?.parcelRefund?.readableId}'.tr,style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
              ]),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            if(rideController.tripDetails?.parcelRefund?.status != RefundStatus.pending) CustomerNoteViewWidget(
              title: rideController.tripDetails?.parcelRefund?.status == RefundStatus.approved ?
              'approval_note'.tr :
              rideController.tripDetails?.parcelRefund?.status == RefundStatus.denied ?
              'denied_note'.tr :
              'refund_note'.tr,

              details: rideController.tripDetails?.parcelRefund?.status == RefundStatus.approved ?
              rideController.tripDetails?.parcelRefund?.approvalNote ?? '' :
              rideController.tripDetails?.parcelRefund?.status == RefundStatus.denied ?
              rideController.tripDetails?.parcelRefund?.denyNote ?? '' :
              rideController.tripDetails?.parcelRefund?.note ?? '',
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),
                  border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:0.25))
              ),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('product_approximate_price'.tr,style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),

                    Text(PriceConverter.convertPrice(rideController.tripDetails?.parcelRefund?.parcelApproximatePrice ?? 0),style: textRobotoBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
                  ]),
                ),

                if(rideController.tripDetails?.parcelRefund?.status == RefundStatus.refunded)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('refunded_amount'.tr,style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall)),

                      Text(PriceConverter.convertPrice(rideController.tripDetails?.parcelRefund?.refundAmountByAdmin ?? 0),style: textRobotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                    ]),
                  ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                if(rideController.tripDetails?.parcelRefund?.refundMethod == 'coupon')
                  InkWell(
                    onTap: (){
                      Get.to(()=> MyOfferScreen(isCoupon: true));
                    },
                    child: Container(
                      width: Get.width,
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).hintColor.withValues(alpha:0.07),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(Dimensions.paddingSizeExtraSmall),
                          bottomRight: Radius.circular(Dimensions.paddingSizeExtraSmall),
                        ),
                      ),
                      child: Center(child: Text(
                        (rideController.tripDetails?.parcelRefund?.isCouponUsed ?? false) ?
                        'coupon_used'.tr : 'check_coupon'.tr,
                        style: textRegular.copyWith(color: Theme.of(context).colorScheme.surfaceContainer),
                      )),
                    ),
                  )

              ]),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            if(rideController.tripDetails?.parcelRefund?.reason?.isNotEmpty ?? false) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                child: Text('refund_reason'.tr,style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).colorScheme.secondaryFixedDim)),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                child: Text(rideController.tripDetails?.parcelRefund?.reason ?? '',style: textSemiBold),
              ),
            ],
            const SizedBox(height: Dimensions.paddingSizeSmall),

            if(rideController.tripDetails?.parcelRefund?.customerNote?.isNotEmpty ?? false)
              CustomerNoteViewWidget(
                title: 'customer_note'.tr,
                details: rideController.tripDetails?.parcelRefund?.customerNote ?? '',
                edgeInsets: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
              ),

            Padding(
              padding: const EdgeInsets.only(
                  top: Dimensions.paddingSizeSmall,left: Dimensions.paddingSizeSmall,
                  right: Dimensions.paddingSizeSmall
              ),
              child: Text('uploaded_medias'.tr,style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).colorScheme.secondaryFixedDim)),
            ),

            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: rideController.tripDetails?.parcelRefund?.attachments?.length,
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // number of items in each row
                      mainAxisSpacing: Dimensions.paddingSizeSmall, // spacing between rows
                      crossAxisSpacing: Dimensions.paddingSizeSmall,
                      childAspectRatio: 2// spacing between columns
                  ),
                  itemBuilder: (context, index){
                    return InkWell(
                      onTap: ()=> Get.to(()=> ImageVideoViewer(attachments: rideController.tripDetails?.parcelRefund?.attachments,fromNetwork: true,clickedIndex: index)),
                      child: Stack(children: [
                        Container(
                          height: 100,
                          width: 200,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondaryFixedDim.withValues(alpha:0.05),
                              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault))
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                            child: (rideController.tripDetails?.parcelRefund?.attachments?[index].file ?? '').contains('.mp4') ?
                            Image.file(File(rideController.thumbnailPaths![index]), fit: BoxFit.cover, errorBuilder: (_, __, ___)=> const SizedBox(),) :
                            ImageWidget(
                              image: rideController.tripDetails?.parcelRefund?.attachments?[index].file ?? '',
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),

                        if((rideController.tripDetails?.parcelRefund?.attachments?[index].file ?? '').contains('.mp4'))
                          Align(alignment: Alignment.center, child: Image.asset(Images.playButtonIcon))
                      ]),
                    );
                  }
              ),
            ),
          ]),
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        if(rideController.tripDetails?.parcelRefund?.status == RefundStatus.pending)
          ButtonWidget(
            backgroundColor: Theme.of(context).primaryColor.withValues(alpha:0.5),
            buttonText: 'refund_request_send'.tr,
            textColor: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha:0.5) : null,
          )
      ]);
    });
  }
}
