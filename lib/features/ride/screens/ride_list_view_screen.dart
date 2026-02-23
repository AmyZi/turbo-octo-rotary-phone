import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/no_data_widget.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/ride/widgets/ride_item_widget.dart';

class RideListViewScreen extends StatelessWidget {
  const RideListViewScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: BodyWidget(
          appBar: AppBarWidget(title: 'ride_list_view'.tr),
          body: GetBuilder<RideController>(builder: (rideController){
            return rideController.runningRideList == null || rideController.runningRideList!.data!.isEmpty ?
            const NoDataWidget(title: 'no_trip_found') :
             ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: rideController.runningRideList?.data?.length,
                itemBuilder: (context, index){
                  return RideItemWidget(tripDetails: rideController.runningRideList?.data?[index], index: index);
                }
            );
          }),
        ),
      ),
    );
  }
}
