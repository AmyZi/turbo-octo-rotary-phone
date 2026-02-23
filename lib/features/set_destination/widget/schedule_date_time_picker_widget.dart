import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/set_destination/widget/time_picker_spinner.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/helper/ride_controller_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ScheduleDateTimePickerWidget extends StatefulWidget {
  final bool fromSetDestinationScreen;
  final String? tripId;
  const ScheduleDateTimePickerWidget({super.key, this.fromSetDestinationScreen = false, this.tripId});

  @override
  State<ScheduleDateTimePickerWidget> createState() => _ScheduleDateTimePickerWidgetState();
}

class _ScheduleDateTimePickerWidgetState extends State<ScheduleDateTimePickerWidget> {
  bool showDatePicker = true;
  bool canUpdate = true;
  @override
  void initState() {
    if(widget.tripId != null){
     final RideController rideController = Get.find<RideController>();
     rideController.setScheduleTripTime(DateTime.parse(rideController.tripDetails?.scheduledAt ?? ''));
     rideController.setScheduleTripDate(rideController.tripDetails?.scheduledAt ?? '');
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.paddingSizeLarge), topRight: Radius.circular(Dimensions.paddingSizeLarge))
      ),
      child: Column(mainAxisSize: MainAxisSize.min, spacing: Dimensions.paddingSizeSmall, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          showDatePicker ?
          const SizedBox() :
          InkWell(
            onTap: (){
              showDatePicker = true;
              canUpdate = true;
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              child: Icon(Icons.arrow_back_outlined, size: 18),
            ),
          ),

          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
            ),
            height: Dimensions.paddingSizeExtraSmall, width: 30,
          ),

          InkWell(
            onTap: ()=> Get.back(),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha:0.2),
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),

              child: Image.asset(Images.crossIcon,height: 10,width: 10),
            ),
          ),
        ]),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Text(showDatePicker ? 'select_pickup_date'.tr : 'select_pickup_time'.tr, style: textSemiBold),

        showDatePicker ?
        Container(
            padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
            ),
            child:SfDateRangePicker(
              backgroundColor: Colors.transparent,
              showNavigationArrow: true,
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args){
                if(args.value != null){
                   Get.find<RideController>().setScheduleTripDate(DateFormat('yyyy-MM-dd').format(args.value));
                }
              },
              initialSelectedDate: RideControllerHelper.dateFormatToShow(Get.find<RideController>().scheduleTripDate),
              maxDate: DateTime.now().add(Duration(seconds: Get.find<ConfigController>().config?.advanceScheduleBookTime ?? 0)),
              minDate: DateTime.now().add(Duration(seconds: Get.find<ConfigController>().config?.minimumScheduleBookTime  ?? 0)),
              selectionMode: DateRangePickerSelectionMode.single,
              todayHighlightColor: Theme.of(context).primaryColor,
              selectionShape: DateRangePickerSelectionShape.circle,
              selectionTextStyle: textRegular.copyWith(color: Theme.of(context).cardColor),
              selectionColor: Theme.of(context).primaryColor,
              headerHeight: 50,
              toggleDaySelection: true,
              enablePastDates: false,
              headerStyle: DateRangePickerHeaderStyle(
                backgroundColor: Colors.transparent,
                textAlign: TextAlign.center,
                textStyle: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).textTheme.bodyLarge!.color!,
                ),
              ),
              monthViewSettings: const DateRangePickerMonthViewSettings(
                dayFormat: 'EE',
                viewHeaderHeight: 40,
                firstDayOfWeek: 1,
                numberOfWeeksInView: 6,
              ),
              monthCellStyle: DateRangePickerMonthCellStyle(
                  todayTextStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color!
                  ),
                  disabledDatesDecoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle
                  ),
                  cellDecoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    shape: BoxShape.circle,
                  ),
                  todayCellDecoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor),
                      shape: BoxShape.circle
                  )
              ),

            )
        ) :
        Container(
          decoration: BoxDecoration(
            color:  Theme.of(context).hintColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
          ),
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: TimePickerSpinner(
            is24HourMode: false,
            normalTextStyle: textRegular.copyWith(color: Theme.of(context).hintColor,fontSize: Dimensions.fontSizeSmall),
            highlightedTextStyle: textMedium.copyWith(
              fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
            alignment: Alignment.topCenter,
            time: RideControllerHelper.timeFormatToShow(Get.find<RideController>().scheduleTripTime),
            isForce2Digits: true,
            itemHeight: Get.height * 0.06,
            itemWidth: Get.width * 0.2,
            onTimeChange: (time) {
               Get.find<RideController>().setScheduleTripTime(time);
               _checkScheduleTripCapable(true);
            },
            scrollOff: (value){
              _checkScheduleTripCapable(value);
            },
          ),
        ),

        GetBuilder<RideController>(builder: (rideController){
          return rideController.isLoading ?
          CircularProgressIndicator(color: Theme.of(context).primaryColor) :
            ButtonWidget(
            buttonText: showDatePicker ? 'next'.tr : widget.tripId != null ? 'update'.tr : 'save'.tr,
            onPressed: canUpdate ? (){
              if(showDatePicker){
                showDatePicker = false;
                _checkScheduleTripCapable(true);
              }else{
                if(widget.tripId != null){
                  rideController.updateScheduleTripTimeDate(widget.tripId).then((value){
                    Get.back();
                  });
                }else{
                  Get.back();
                  rideController.setRideType(RideType.scheduleRide, isUpdate: true);
                  if(!widget.fromSetDestinationScreen){
                    rideController.getEstimatedFare(false);
                  }
                }
              }

            } : null,
          );
        }),
        const SizedBox(height: Dimensions.paddingSizeSmall)

      ]),
    );
  }

  void  _checkScheduleTripCapable(bool canSave){
    DateTime scheduleDate = RideControllerHelper.dateFormatToShow(Get.find<RideController>().scheduleTripDate);
    DateTime scheduleTime = RideControllerHelper.timeFormatToShow(Get.find<RideController>().scheduleTripTime);

    DateTime finalDateTime = DateTime(scheduleDate.year,scheduleDate.month,scheduleDate.day,scheduleTime.hour,scheduleTime.minute,scheduleTime.second);

    int timeDifference = finalDateTime.difference(DateTime.now()).inSeconds;

    if((timeDifference >= (Get.find<ConfigController>().config?.minimumScheduleBookTime ?? 0) && canSave && (timeDifference < (Get.find<ConfigController>().config?.advanceScheduleBookTime ?? 0)))){
      setState(() {
        canUpdate = true;
      });
    }else{
      setState(() {
        canUpdate = false;
      });
    }
  }
}
