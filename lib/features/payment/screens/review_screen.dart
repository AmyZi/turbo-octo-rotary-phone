import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/dashboard/controllers/bottom_menu_controller.dart';
import 'package:ride_sharing_user_app/features/payment/controllers/payment_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';

class ReviewScreen extends StatefulWidget {
  final String tripId;
  const ReviewScreen({super.key, required this.tripId});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  TextEditingController reviewTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: PopScope(canPop: false,
        onPopInvokedWithResult: (didPop, val) async {
          Get.offAll(()=> const DashboardScreen());
          return;
        },
        child: Scaffold(
          body: GetBuilder<PaymentController>(builder: (paymentController) {
            return BodyWidget(
              appBar: AppBarWidget(title: 'how_was_your_feeling'.tr,
                onBackPressed: () => Get.find<BottomMenuController>().navigateToDashboard()),
              body: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

                  Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeOverLarge),
                    child: Center(child: Text('payment_successful'.tr,
                      style: textSemiBold.copyWith(color: Theme.of(context).primaryColor)))),

                  Text('review'.tr, style: textSemiBold.copyWith(color: Theme.of(context).primaryColor),),
                  Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                    child: Text('share_your_feeling_with_us'.tr,
                      style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color, fontSize: Dimensions.fontSizeSmall))),

                  SizedBox(height: 80, child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: paymentController.reviewTypeList.length,
                    itemBuilder: (context, index) {
                      return  ReviewItem(index: index, selectedIndex: paymentController.reviewTypeSelectedIndex,
                        reviewModel: paymentController.reviewTypeList[index]);
                    },
                  )),

                  Padding(padding: const EdgeInsets.only(top: 45, bottom: Dimensions.paddingSizeSmall),
                    child: Text('leave_us_a_comment'.tr, style: textRegular)),
                  TextFormField(
                    controller: reviewTextController,
                    maxLines: 5,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).hintColor.withValues(alpha:.1),
                      hintText: 'your_feedback'.tr,
                      hintStyle: textRegular.copyWith(color: Theme.of(context).hintColor.withValues(alpha:.5)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                        borderSide:  BorderSide(width: 0.5,
                            color: Theme.of(context).hintColor.withValues(alpha:0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                        borderSide:  BorderSide(width: 0.5, color: Theme.of(context).primaryColor.withValues(alpha:0.5)),
                      ),
                    ),
                  ),
                ]),
              ),
            );
          }),

          bottomNavigationBar: GetBuilder<PaymentController>(builder: (reviewController) {
            return Container(
              height: 80,
              color: Theme.of(context).cardColor,
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: reviewController.isLoading ? Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,)) : ButtonWidget(
                buttonText: 'submit'.tr, onPressed: () {
                  reviewController.submitReview(widget.tripId, reviewController.reviewTypeSelectedIndex + 1, reviewTextController.text);
                },
              ),
            );
          }),

        ),
      ),
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
    return InkWell(
      onTap: () => Get.find<PaymentController>().setReviewType(index),
      child: SizedBox(
        width: 75,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [

          index == selectedIndex ? Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha:.125),
              borderRadius: BorderRadius.circular(100),
            ),
            child: SizedBox(width: 25,child: Image.asset(reviewModel.icon!)),
          ) : SizedBox(width: 15,child: Image.asset(reviewModel.icon!)),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          Text(
            reviewModel.title!.tr,
            style: index == selectedIndex ? textMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color)
                : textRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
          ),

        ]),
      ),
    );
  }
}




