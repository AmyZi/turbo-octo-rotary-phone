
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/payment/controllers/payment_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/widget/coupon_use_result_dialog.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';

class UseCouponScreen extends StatefulWidget {
  const UseCouponScreen({super.key});

  @override
  State<UseCouponScreen> createState() => _UseCouponScreenState();
}

class _UseCouponScreenState extends State<UseCouponScreen> {
  TextEditingController couponController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<PaymentController>(
          builder: (paymentController) {
            return BodyWidget(
              appBar: AppBarWidget(title: 'add_voucher_code'.tr,),
              body: SingleChildScrollView(
                child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

                    Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeOverLarge),
                      child: Text('voucher_code'.tr, style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge))),


                    SizedBox(height: 40,
                      child: TextFormField(
                        controller: couponController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          fillColor: Theme.of(context).hintColor.withValues(alpha:.1),
                          hintText: 'enter_voucher_code'.tr,
                          hintStyle: textRegular.copyWith(color: Theme.of(context).hintColor.withValues(alpha:.5)),
                          enabledBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                            borderSide:  BorderSide(width: 0.5, color: Theme.of(context).hintColor.withValues(alpha:0.5))),
                          focusedBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                            borderSide:  BorderSide(width: 0.5, color: Theme.of(context).primaryColor.withValues(alpha:0.5)))))),


                    Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                      child: Text('enter_voucher_code_hint'.tr, style: textRegular.copyWith())),


                  ],),
                ),),
            );
          }
      ),

      bottomNavigationBar: Container(height: 80,
        color: Theme.of(context).cardColor,
        child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: ButtonWidget(buttonText: 'continue'.tr, onPressed: (){
            String coupon = couponController.text;
            if (coupon.isEmpty){
              showCustomSnackBar('coupon_code_is_required'.tr);
            }else{
              showDialog(context: context, builder: (_){
                return  CouponUserResultDialog(icon: Images.success,
                  title: 'your_code_is_applied_for_next_trip'.tr,
                  onTap: ()=> Get.back());});}
            },),
        ),),
    );
  }
}


class ReviewItem extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final ReviewModel reviewModel;
  const ReviewItem({super.key, required this.index, required this.selectedIndex, required this.reviewModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> Get.find<PaymentController>().setReviewType(index),
      child: SizedBox(width: 80,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,children: [
          index == selectedIndex ?
          Container(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor.withValues(alpha:.125),
                  borderRadius: BorderRadius.circular(100)),
              child: SizedBox(width: 50,child: Image.asset(reviewModel.icon!))):


          SizedBox(width: 30,child: Image.asset(reviewModel.icon!)),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
          Text(reviewModel.title!.tr, style: index==selectedIndex
                ? textMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color)
                :textRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall))


        ],),
      ),
    );
  }
}




