import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/custom_pop_scope_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/loader_widget.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/payment/screens/review_screen.dart';
import 'package:ride_sharing_user_app/features/refund_request/screens/refund_request_screen.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/safety_setup/controllers/safety_alert_controller.dart';
import 'package:ride_sharing_user_app/features/safety_setup/widgets/safety_alert_bottomsheet_widget.dart';
import 'package:ride_sharing_user_app/features/set_destination/widget/schedule_date_time_picker_widget.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/parcel_details_widget.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/parcel_returning_process_widget.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/refund_details_widget.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/trip_details.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/trip_details_top_section_widget.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/trip_safety_sheet_details_widget.dart';
import 'package:ride_sharing_user_app/helper/trip_details_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class TripDetailsScreen extends StatefulWidget {
  final String tripId;
  final bool fromNotification;
  const TripDetailsScreen({super.key, required this.tripId,this.fromNotification = false});

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {

  JustTheController toolTipController = JustTheController();

  @override
  void initState() {
    if(!widget.fromNotification){
      Get.find<RideController>().getRideDetails(widget.tripId, isUpdate: false);
    }
    super.initState();
  }

  @override
  void dispose() {
    toolTipController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: CustomPopScopeWidget(
        child: Scaffold(
          body: GetBuilder<RideController>(builder: (rideController){
            if(rideController.tripDetails?.customerSafetyAlert != null){
              showToolTips();
            }
            return PopScope(
              onPopInvokedWithResult: (didPop, val){
                rideController.clearRideDetails();
              },
              child: BodyWidget(
                appBar: AppBarWidget(
                  title: (rideController.tripDetails?.currentStatus ?? '').tr,
                  subTitle: rideController.tripDetails != null ?
                  '${rideController.tripDetails?.type == 'parcel' ? 'parcel'.tr : 'trip'.tr} #${rideController.tripDetails?.refId}' : '',
                  showBackButton: true, centerTitle: true,
                ),
                body: GetBuilder<TripController>(builder: (activityController) {
                  return rideController.tripDetails != null ?
                  Stack(children: [
                    Column(children: [
                      Expanded(child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          child: Column(children: [
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            TripDetailsTopSectionWidget(tripDetails: rideController.tripDetails),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            rideController.tripDetails?.type == 'parcel' ?
                            ParcelDetailsWidget(tripDetails: rideController.tripDetails!) :
                            TripDetailWidget(tripDetails: rideController.tripDetails!),

                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                            if(rideController.tripDetails?.parcelRefund != null)...[
                              RefundDetailsWidget()
                            ],
                            const SizedBox(height: Dimensions.paddingSizeDefault),

                            if(TripDetailsHelper.isShowRefundRequestButton(rideController))...[

                              Text('if_your_parcel_is_damaged'.tr,style: textRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).colorScheme.secondaryFixedDim
                              ),textAlign: TextAlign.center),
                              const SizedBox(height: Dimensions.paddingSizeSeven),

                              InkWell(
                                onTap: ()=> Get.to(()=> RefundRequestScreen(tripId: widget.tripId)),
                                child: Text('refund_request'.tr, style: textRegular.copyWith(
                                    decoration: TextDecoration.underline,
                                    decorationColor: Theme.of(context).colorScheme.inverseSurface,
                                    color: Theme.of(context).colorScheme.inverseSurface
                                )),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeDefault),
                            ],

                            if(rideController.tripDetails?.type == 'scheduled_request')...[
                              _ShowScheduleTripEditCancelButton(tripId: widget.tripId),
                              const SizedBox(height: Dimensions.paddingSizeDefault),
                            ],

                          ]),
                        ),
                      )),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      if(rideController.tripDetails?.currentStatus == 'returning' && rideController.tripDetails?.type == 'parcel')...[
                        ParcelReturningProcessWidget()
                      ],

                      (TripDetailsHelper.isReviewButtonShow(rideController)) ?
                      Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha: 0.1), blurRadius: 2,spreadRadius: 3,offset: Offset(0, -2))]
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                        child: ButtonWidget(
                          icon: Icons.star_border,
                          buttonText: 'give_review'.tr,
                          onPressed: () => Get.to(() => ReviewScreen(tripId: widget.tripId)),
                        ),
                      ) : const SizedBox()
                    ]),

                    if(rideController.tripDetails?.customerSafetyAlert != null)
                      Positioned(
                        right: Dimensions.paddingSizeDefault *2,
                        height: Get.height * 0.2,
                        child: JustTheTooltip(
                          backgroundColor: Get.isDarkMode ?
                          Theme.of(context).primaryColor :
                          Theme.of(context).textTheme.bodyMedium!.color,
                          controller: toolTipController,
                          preferredDirection: AxisDirection.right,
                          tailLength: 10,
                          tailBaseWidth: 20,
                          content: Container(width: Get.width * 0.5,
                            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            child: Text(
                              'tap_to_see_safety_details'.tr,
                              style: textRegular.copyWith(
                                color: Colors.white, fontSize: Dimensions.fontSizeSmall,
                              ),
                            ),
                          ),
                          child: InkWell(
                            onTap: ()=> Get.bottomSheet(
                              isScrollControlled: true,
                              TripSafetySheetDetailsWidget(tripDetails: rideController.tripDetails!),
                              backgroundColor: Theme.of(context).cardColor,isDismissible: false,
                            ),
                            child: Image.asset(Images.safelyShieldIcon3,height: 24,width: 24),
                          ),
                        ),
                      ),

                    if(TripDetailsHelper.isShowSafetyFeature(rideController.tripDetails!))
                      Positioned(
                        bottom: Get.height * 0.1, right: 10,
                        child: InkWell(
                          onTap: (){
                            Get.find<SafetyAlertController>().updateSafetyAlertState(SafetyAlertState.initialState);
                            Get.bottomSheet(
                              isScrollControlled: true,
                              const SafetyAlertBottomSheetWidget(fromTripDetailsScreen: true),
                              backgroundColor: Theme.of(context).cardColor,isDismissible: false,
                            );
                          },
                          child: Image.asset(Images.safelyShieldIcon3,height: 40,width: 40),
                        ),
                      )
                  ]) :
                  const LoaderWidget();
                }),
              ),
            );
          }),
        ),
      ),
    );
  }

  void showToolTips(){
    WidgetsBinding.instance.addPostFrameCallback((_){
      Future.delayed(const Duration(milliseconds: 500)).then((_){
        toolTipController.showTooltip();
      });
    });
  }

}

class _ShowScheduleTripEditCancelButton extends StatelessWidget {
  final String tripId;
  const _ShowScheduleTripEditCancelButton({required this.tripId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (rideController){
      return Column(children: [
        if(rideController.tripDetails?.currentStatus == 'pending')
          ButtonWidget(
            buttonText: 'edit_schedule'.tr,
            onPressed: () => Get.bottomSheet(ScheduleDateTimePickerWidget(fromSetDestinationScreen: true, tripId: tripId),enableDrag: false, isScrollControlled: true),
          ),

        if(rideController.tripDetails?.currentStatus != 'cancelled')
          GetBuilder<RideController>(builder: (rideController){
            return rideController.isLoading ?
            CircularProgressIndicator(color: Theme.of(context).primaryColor) :
            ButtonWidget(
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).colorScheme.error,
              buttonText: 'cancel_trip'.tr,
              onPressed: () {
                Get.find<RideController>().tripStatusUpdate(tripId, 'cancelled', 'ride_request_cancelled_successfully','').then((value){
                  if(value.statusCode == 200){
                    Get.offAll(const DashboardScreen());
                  }
                });
              },
            );
          })
      ]);
    });
  }
}


