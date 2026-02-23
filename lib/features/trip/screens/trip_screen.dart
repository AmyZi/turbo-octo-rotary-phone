import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/custom_pop_scope_widget.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/trip_item_view.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';
import 'package:ride_sharing_user_app/features/notification/widgets/notification_shimmer.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/no_data_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/paginated_list_widget.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class TripScreen extends StatefulWidget {
  final bool fromProfile;
  const TripScreen({super.key, required this.fromProfile});

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> with SingleTickerProviderStateMixin{
  late TabController tabController;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    tabController = TabController(length: 5, vsync: this);
    Get.find<TripController>().initData();
    Get.find<TripController>().getTripList(1);
    tabController.addListener((){
      if (!tabController.indexIsChanging){
        Get.find<TripController>().setStatusIndex(tabController.index);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: CustomPopScopeWidget(
        child: Scaffold(
          body: BodyWidget(
            appBar: AppBarWidget(title: 'trip_history'.tr, showBackButton: widget.fromProfile,centerTitle: true,showTripHistoryFilter: true),
            body: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: GetBuilder<TripController>(builder: (tripController) {
                return Column(children: [
                  TabBar(
                    controller: tabController,
                    unselectedLabelColor: Colors.grey,
                    tabAlignment: TabAlignment.start,
                    isScrollable: true,
                    labelColor: Get.isDarkMode ? Colors.white.withValues(alpha:0.9) : Theme.of(context).primaryColor,
                    labelStyle: textSemiBold.copyWith(),
                    indicator: UnderlineTabIndicator(borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1)),
                    dividerHeight: 1,
                    dividerColor: Theme.of(context).primaryColor.withValues(alpha:0.15),
                    tabs: [
                      Tab(text: 'all_trip'.tr),
                      Tab(text: 'ongoing'.tr),
                      Tab(text: 'cancelled'.tr),
                      Tab(text: 'completed'.tr),
                      Tab(text: 'returned'.tr)
                    ],
                  ),

                  Expanded(child: TabBarView(
                      controller: tabController,
                      children: [
                        tabBarBodyWidget(tripController),
                        tabBarBodyWidget(tripController),
                        tabBarBodyWidget(tripController),
                        tabBarBodyWidget(tripController),
                        tabBarBodyWidget(tripController)
                      ]
                  ))

                ]);
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget tabBarBodyWidget (TripController tripController){
    return (tripController.tripModel != null && tripController.tripModel!.data != null) ?
    tripController.tripModel!.data!.isNotEmpty ?
    SingleChildScrollView(
      controller: scrollController,
      child: PaginatedListWidget(
        scrollController: scrollController,
        totalSize: tripController.tripModel!.totalSize,
        offset:
        (tripController.tripModel != null && tripController.tripModel!.offset != null) ?
        int.parse(tripController.tripModel!.offset.toString()) :
        null,
        onPaginate: (int? offset) async {
          await tripController.getTripList(offset!);
        },
        itemView: Padding(
          padding: const EdgeInsets.only(bottom: 70.0),
          child: ListView.separated(
            itemCount: tripController.tripModel!.data!.length,
            padding: const EdgeInsets.all(0),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return TripItemView(tripDetails: tripController.tripModel!.data![index]);
            },
            separatorBuilder: (BuildContext context, int index) => Divider(color: Theme.of(context).highlightColor.withValues(alpha:0.15)),
          ),
        ),
      ),
    ) :
    const NoDataWidget(title: 'no_trip_found') :
    const NotificationShimmer();
  }
}

