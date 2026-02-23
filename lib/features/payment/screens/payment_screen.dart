import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/route_widget.dart';
import 'package:ride_sharing_user_app/features/payment/screens/digital_payment_screen.dart';
import 'package:ride_sharing_user_app/features/payment/widget/apply_coupon.dart';
import 'package:ride_sharing_user_app/features/payment/widget/digital_card_payment_widget.dart';
import 'package:ride_sharing_user_app/features/payment/widget/payment_type_item_widget.dart';
import 'package:ride_sharing_user_app/features/payment/widget/tips_widget.dart';
import 'package:ride_sharing_user_app/features/ride/widgets/trip_fare_summery.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/coupon/controllers/coupon_controller.dart';
import 'package:ride_sharing_user_app/features/dashboard/controllers/bottom_menu_controller.dart';
import 'package:ride_sharing_user_app/features/payment/controllers/payment_controller.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';

class PaymentScreen extends StatefulWidget {
  final bool fromParcel;
  const PaymentScreen({super.key,  this.fromParcel = false});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> with WidgetsBindingObserver{
  bool collapsed = false;
  TextEditingController tipsAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if(Get.find<ProfileController>().profileModel?.data?.wallet == null){
      Get.find<ProfileController>().getProfileInfo();
    }
    Get.find<PaymentController>().initPayment();
    Get.find<PaymentController>().getPaymentGetWayList();
    Get.find<PaymentController>().setPaymentByName(Get.find<RideController>().tripDetails?.paymentMethod??'cash');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.resumed){
      Get.find<RideController>().getRideDetails(Get.find<RideController>().currentTripDetails!.id!).then((value) {
        if(Get.find<RideController>().currentTripDetails!.paymentStatus == 'paid'){
          Get.offAll(()=> const DashboardScreen());
        }else{
          Get.find<RideController>().getFinalFare(Get.find<RideController>().currentTripDetails!.id!);
          Get.find<PaymentController>().initPayment();
          Get.find<PaymentController>().getPaymentGetWayList();
          Get.find<PaymentController>().setPaymentByName(Get.find<RideController>().tripDetails?.paymentMethod??'cash');
        }
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      top: false,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, val) async {
          Get.find<BottomMenuController>().navigateToDashboard();
          return;
        },
        child: Scaffold(
          body: GetBuilder<PaymentController>(builder: (paymentController) {
            tipsAmountController.text = '${'tips'.tr}-${'\$${paymentController.tipAmount}'}';
              return BodyWidget(
                appBar: AppBarWidget(
                  title: 'payment'.tr,
                  onBackPressed: () => Get.find<BottomMenuController>().navigateToDashboard(),
                ),
                body: GetBuilder<CouponController>(builder: (couponController) {
                  return SingleChildScrollView(child: Column(children: [

                    GetBuilder<RideController>(builder: (rideController){

                      String firstRoute = '';
                      String secondRoute = '';
                      List<dynamic> extraRoute = [];
                      if(rideController.tripDetails?.intermediateAddresses != null &&
                          rideController.tripDetails?.intermediateAddresses != '["",""]'){
                        extraRoute = jsonDecode(rideController.tripDetails!.intermediateAddresses!);

                        if(extraRoute.isNotEmpty) {
                          firstRoute = extraRoute[0];
                        }
                        if(extraRoute.isNotEmpty && extraRoute.length > 1) {
                          secondRoute = extraRoute[1];
                        }
                      }

                      return Column(children: [
                        Padding(padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault,
                          vertical: Dimensions.paddingSizeExtraLarge,
                        ),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                            Text('payment'.tr,
                              style: textSemiBold.copyWith(color: Theme.of(context).primaryColor),
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal : Dimensions.paddingSizeExtraSmall,
                                vertical: Dimensions.paddingSizeThree,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withValues(alpha:.2),
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                              ),
                              child: Row(children: [
                                Text(paymentController.paymentType.tr,
                                  style: textMedium.copyWith(color: Theme.of(context).primaryColor),
                                ),

                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                SizedBox(width: Dimensions.iconSizeSmall,
                                  child: Image.asset(Images.cash),
                                ),
                              ]),
                            ),
                          ]),
                        ),

                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text('this_trip_is'.tr),

                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                          if(rideController.finalFare != null && rideController.finalFare!.currentStatus != null)
                            Text(rideController.finalFare!.currentStatus!.capitalize!,
                              style: textSemiBold.copyWith(color: Theme.of(context).primaryColor),
                            ),
                        ]),

                        (rideController.finalFare != null) ?
                        Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                          child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                              Text(
                                PriceConverter.convertPrice(
                                  rideController.finalFare!.paidFare! + double.parse(paymentController.tipAmount),
                                ),
                                style: textRobotoMedium.copyWith(fontSize: Dimensions.fontSizeOverLarge,
                                  color: Theme.of(context).textTheme.bodyMedium!.color,
                                ),
                              ),
                            const SizedBox(width: Dimensions.paddingSizeSmall),

                            if(double.parse(paymentController.tipAmount) > 0)
                            Text('( ${'tips_added'.tr} )')
                            ]),
                        ) : const SizedBox(),

                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text('your'.tr, style: textMedium.copyWith(
                            color: Theme.of(context).textTheme.bodyMedium!.color,
                          )),

                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                          Text('total_fare'.tr, style: textSemiBold.copyWith(
                            color: Theme.of(context).primaryColor,
                          )),

                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                          Text('for_this_trip'.tr, style: textMedium.copyWith(
                            color: Theme.of(context).textTheme.bodyMedium!.color,
                          )),

                        ]),


                        Row(crossAxisAlignment: paymentController.paymentTypeIndex == 2 ?
                         CrossAxisAlignment.end : CrossAxisAlignment.center, children: [
                          Expanded(child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: paymentController.paymentTypeList.length,
                            itemBuilder: (context, index){
                              return PaymentTypeItem(
                                title: paymentController.paymentTypeList[index],
                                index: index,
                                selectedIndex: paymentController.paymentTypeIndex,
                              );
                            },
                          )),

                          paymentController.paymentTypeIndex == 2 ?
                          GetBuilder<ProfileController>(builder: (profileController) {
                            return Padding(padding:const EdgeInsets.all(Dimensions.paddingSizeDefault),
                              child: Text.rich(
                                TextSpan(children: [TextSpan(text: '${'available'.tr}: ',
                                  style: textRegular.copyWith(color: Theme.of(context).hintColor),
                                ),
                                  TextSpan(text: PriceConverter.convertPrice(
                                    profileController.profileModel?.data?.wallet?.walletBalance ?? 0,
                                  ),
                                    style: textRobotoMedium.copyWith(color: Theme.of(context).hintColor),
                                  ),
                                ]),
                              ),
                            );
                          }) : const SizedBox(),
                        ],
                        ),

                        paymentController.paymentTypeIndex == 1 ?
                        Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge),
                          child: SizedBox(height: 105, child: ListView.builder(
                            itemCount: paymentController.paymentGateways?.length,
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index){
                              return DigitalCardPaymentWidget(
                                digitalPaymentModel: paymentController.paymentGateways![index],
                                index: index,
                              );
                            },
                          )),
                        ) : const SizedBox(),

                        paymentController.paymentTypeIndex == 1 ?
                        Container(width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(left:Dimensions.paddingSizeDefault,
                            right:Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeDefault,
                            top: Dimensions.paddingSizeExtraSmall,
                          ),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(
                            Dimensions.paddingSizeExtraSmall,
                          ),
                              border: Border.all(width: .5,
                                color: Theme.of(context).primaryColor.withValues(alpha:.9),
                              ),
                          ),
                          child: Row(children: [
                            Expanded(child: SizedBox(child: Padding(
                              padding: EdgeInsets.only(
                                left: Get.find<LocalizationController>().isLtr ?
                                Dimensions.paddingSizeExtraSmall : 0,
                                right: Get.find<LocalizationController>().isLtr ? 0 :
                                Dimensions.paddingSizeExtraSmall,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal:Dimensions.iconSizeSmall,
                                  vertical: Dimensions.paddingSizeSmall,
                                ),
                                child: Text(
                                  (paymentController.tipAmount == '0' ||
                                      paymentController.tipAmount.isEmpty) ?
                                  'give_tips'.tr :
                                  '${'tips'.tr}: ${PriceConverter.convertPrice(
                                      double.parse(paymentController.tipAmount))}',
                                  style: textRobotoMedium.copyWith(color: Theme.of(context).primaryColorDark),
                                ),
                              ),
                            ))),

                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            InkWell(
                              onTap: () => showDialog(barrierDismissible: false,
                                context: context, builder: (_) => const TipsWidget(),
                              ),
                              child: Container(
                                padding:const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeSmall,
                                  vertical: Dimensions.paddingSizeSmall,
                                ),
                                margin:const  EdgeInsets.all(Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(color: Theme.of(context).primaryColor.withValues(alpha:.35),
                                  borderRadius:const BorderRadius.all(
                                      Radius.circular(Dimensions.paddingSizeSmall)),
                                ),
                                child: Center(child: Text(
                                  (paymentController.tipAmount == '0' || paymentController.tipAmount.isEmpty) ?
                                  'add_tips'.tr : 'change'.tr, style: textBold.copyWith(
                                  color: Theme.of(context).primaryColorDark,
                                  fontSize: Dimensions.fontSizeDefault,
                                ),
                                )),
                              ),
                            ),
                          ]),
                        ) : const SizedBox(),

                        Padding(padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault),
                          child: Theme(data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(initiallyExpanded: true,
                              tilePadding:collapsed ? EdgeInsets.zero :
                              const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                              collapsedBackgroundColor: Theme.of(context).primaryColor.withValues(alpha:.4),
                              collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('trip_details'.tr,
                                      style: textMedium.copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: Dimensions.fontSizeLarge,
                                      )
                                  ),
                                ],
                              ),
                              onExpansionChanged: (bool expanded){
                                setState(() {
                                  collapsed = expanded;
                                });
                              },
                              children: [
                                const SizedBox(height: Dimensions.paddingSizeSmall),

                                if(rideController.tripDetails != null)
                                  RouteWidget(
                                    totalDistance: rideController.finalFare?.actualDistance?.toString()??'0',
                                    fromAddress: rideController.tripDetails!.pickupAddress!,
                                    toAddress: rideController.tripDetails!.destinationAddress!,
                                    extraOneAddress: firstRoute,
                                    extraTwoAddress: secondRoute,
                                    entrance:  rideController.tripDetails!.entrance ?? '',
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ]);

                    }),

                    Get.find<RideController>().finalFare != null ? Column(children: [
                      TripFareSummery(fromPayment: true,
                          tripFare: Get.find<RideController>().finalFare!.paidFare!,
                          fromParcel: widget.fromParcel,
                      ),

                      ApplyCoupon(tripId: Get.find<RideController>().finalFare!.id!),

                    ]) : const SizedBox(),

                  ]));
                }),
              );

          }),

          bottomNavigationBar: GetBuilder<PaymentController>(builder: (paymentController) {
            return Container(color: Theme.of(context).cardColor, height: 80,
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,
                vertical: Dimensions.paddingSizeDefault,
              ),

              child: paymentController.isLoading ?
              Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,)) :
              ButtonWidget(buttonText: 'pay_now'.tr,
                onPressed: () {
                  if(paymentController.paymentTypeIndex == 1 && paymentController.paymentGatewayIndex != -1)
                  {
                    Get.to(() => DigitalPaymentScreen(
                      tripId: Get.find<RideController>().finalFare!.id!,
                      paymentMethod: paymentController.gateWay,
                      fromParcel: widget.fromParcel,
                      tips: paymentController.tipAmount,
                    ));

                  }
                  if(paymentController.paymentTypeIndex == 1 && paymentController.paymentGatewayIndex == -1)
                  {
                    showCustomSnackBar('select_payment_method'.tr);
                  }else if(paymentController.paymentTypeIndex == 0 || paymentController.paymentTypeIndex == 2) {
                    if(Get.find<RideController>().finalFare != null){
                      paymentController.paymentSubmit(Get.find<RideController>().finalFare!.id!,
                        paymentController.paymentTypeList[paymentController.paymentTypeIndex],
                        fromParcel: widget.fromParcel,
                      );
                    }
                  }
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}





