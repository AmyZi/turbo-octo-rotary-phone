import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';
import 'package:ride_sharing_user_app/features/my_level/controller/level_controller.dart';
import 'package:ride_sharing_user_app/features/notification/widgets/notification_shimmer.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class MyLevelScreen extends StatefulWidget {
  const MyLevelScreen({super.key});

  @override
  State<MyLevelScreen> createState() => _MyLevelScreenState();
}

class _MyLevelScreenState extends State<MyLevelScreen> {
  @override
  void initState() {
    Get.find<LevelController>().getProfileLevelInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: BodyWidget(
          appBar: AppBarWidget(title: 'my_level'.tr, showBackButton: true),
          body: GetBuilder<LevelController>(builder: (levelController){
            return levelController.levelModel == null ?
            const NotificationShimmer():
            Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Column(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: ImageWidget(height: 70, width: 70,
                    image: Get.find<ProfileController>().profileModel?.data?.profileImage != null ?
                    '${Get.find<ConfigController>().config!.imageBaseUrl!.profileImage!}/'
                        '${Get.find<ProfileController>().profileModel?.data?.profileImage??''}':'',
                    placeholder: Images.personPlaceholder, fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Text(Get.find<ProfileController>().customerName(),
                  style: textBold.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color,
                    fontSize: Dimensions.fontSizeSmall,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(levelController.levelModel?.data?.currentLevel?.name ?? '',
                    style: textBold.copyWith(color: Theme.of(context).hintColor,
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  ),

                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  ImageWidget( height: 16,width: 16,
                    image: '${Get.find<ConfigController>().config?.imageBaseUrl?.level}/'
                        '${levelController.levelModel?.data?.currentLevel?.image}',
                  )
                ]),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                if(!levelController.levelModel!.data!.isCompleted!)
                Align(
                  alignment: Get.find<LocalizationController>().isLtr ?
                  Alignment.centerLeft : Alignment.centerRight,
                  child: Text('target'.tr,
                    style: textBold.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color,
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  ),
                ),

                if(!levelController.levelModel!.data!.isCompleted!)
                Row(children: [
                  Expanded(child: LinearProgressIndicator(
                    value: _calculateProgressValue(
                      _calculateTotalTargetPoint(
                        levelController.levelModel?.data?.completedCurrentLevelTarget?.rideCompletePoint ?? 0,
                        levelController.levelModel?.data?.completedCurrentLevelTarget?.spendAmountPoint ?? 0,
                        levelController.levelModel?.data?.completedCurrentLevelTarget?.cancellationRatePoint ?? 0,
                        levelController.levelModel?.data?.completedCurrentLevelTarget?.reviewGivenPoint ?? 0,
                      ),
                      _calculateTotalTargetPoint(
                        levelController.levelModel?.data?.currentLevel?.targetedRidePoint ?? 1,
                        levelController.levelModel?.data?.currentLevel?.targetedAmountPoint ?? 0,
                        levelController.levelModel?.data?.currentLevel?.targetedCancelPoint ?? 0,
                        levelController.levelModel?.data?.currentLevel?.targetedReviewPoint ?? 0,
                      ),
                    ),
                    minHeight: Dimensions.paddingSizeExtraSmall,
                    backgroundColor: Theme.of(context).hintColor.withValues(alpha:0.25),
                  )),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  if(levelController.levelModel?.data?.nextLevel != null)
                  Image.network(height: 30,width: 30,
                    '${Get.find<ConfigController>().config?.imageBaseUrl?.level}/'
                        '${levelController.levelModel?.data?.nextLevel?.image}',
                  )
                ]),

                if(!levelController.levelModel!.data!.isCompleted!)
                Align(
                  alignment: Get.find<LocalizationController>().isLtr ?
                  Alignment.centerLeft : Alignment.centerRight,
                  child: Text.rich(TextSpan(children: [
                    TextSpan(
                      text: 'earn_more'.tr,
                      style: textRegular.copyWith(color: Theme.of(context).hintColor),
                    ),
                    TextSpan(
                      text: ' ${_calculateTotalTargetPoint(
                        levelController.levelModel?.data?.completedCurrentLevelTarget?.rideCompletePoint ?? 0,
                        levelController.levelModel?.data?.completedCurrentLevelTarget?.spendAmountPoint ?? 0,
                        levelController.levelModel?.data?.completedCurrentLevelTarget?.cancellationRatePoint ?? 0,
                        levelController.levelModel?.data?.completedCurrentLevelTarget?.reviewGivenPoint ?? 0,
                      ).toInt()}/${_calculateTotalTargetPoint(
                        levelController.levelModel?.data?.currentLevel?.targetedRidePoint ?? 0,
                        levelController.levelModel?.data?.currentLevel?.targetedAmountPoint ?? 0,
                        levelController.levelModel?.data?.currentLevel?.targetedCancelPoint ?? 0,
                        levelController.levelModel?.data?.currentLevel?.targetedReviewPoint ?? 0,
                      ).toInt()} ',
                      style: textRegular.copyWith(color: Theme.of(context).primaryColor),
                    ),
                    TextSpan(
                      text: 'point_for_next_level'.tr,
                      style: textBold.copyWith(color: Theme.of(context).hintColor),
                    ),
                  ])),
                ),
                if(!levelController.levelModel!.data!.isCompleted!)
                const SizedBox(height: Dimensions.paddingSizeLarge),

               !(((levelController.levelModel?.data?.currentLevel?.targetedRide ?? 0) <=
                   (levelController.levelModel?.data?.completedCurrentLevelTarget?.rideComplete ?? 0)) &&
                   ((levelController.levelModel?.data?.currentLevel?.targetedAmount ?? 0) <=
                       (levelController.levelModel?.data?.completedCurrentLevelTarget?.spendAmount ?? 0)) &&
                   ((levelController.levelModel?.data?.currentLevel?.targetedReview ?? 0) <=
                       (levelController.levelModel?.data?.completedCurrentLevelTarget?.reviewGiven ?? 0)) &&
                   ((levelController.levelModel?.data?.currentLevel?.targetedCancel ?? 0) >=
                       (levelController.levelModel?.data?.completedCurrentLevelTarget?.cancellationRate ?? 0))) ?
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(children: [
                      if((levelController.levelModel?.data?.currentLevel?.targetedRide?.toInt() ?? 0) > 0)...[
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                              border: Border.all(color: Theme.of(context).hintColor.withValues(alpha:0.25))
                          ),
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            TargetNotificationTitle(
                              completedValue:
                              levelController.levelModel?.data?.completedCurrentLevelTarget?.rideComplete ?? 0,
                              targetValue: levelController.levelModel?.data?.currentLevel?.targetedRide ?? 0,
                            ),

                            Text(_targetNotificationSubTitle(
                                levelController.levelModel?.data?.completedCurrentLevelTarget?.rideComplete ?? 0,
                                levelController.levelModel?.data?.currentLevel?.targetedRide ?? 0
                            ),
                              style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!,
                                fontSize: Dimensions.fontSizeSmall,
                              ),
                            ),

                            const SizedBox(height: Dimensions.paddingSizeDefault),
                            Text('trips_completed'.tr,
                              style: textBold.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!,
                                fontSize: Dimensions.fontSizeSmall,
                              ),
                            ),

                            Row(children: [
                              Expanded(child: LinearProgressIndicator(
                                value: _calculateProgressValue(
                                  levelController.levelModel?.data?.completedCurrentLevelTarget?.rideComplete ?? 0,
                                  levelController.levelModel?.data?.currentLevel?.targetedRide ?? 0,
                                ),
                                minHeight: Dimensions.paddingSizeExtraSmall,
                                backgroundColor: Theme.of(context).hintColor.withValues(alpha:0.25),
                              )),

                              Image.asset(height: 30,width: 30,
                                _targetCompleteIcon(
                                  levelController.levelModel?.data?.completedCurrentLevelTarget?.rideComplete ?? 0,
                                  levelController.levelModel?.data?.currentLevel?.targetedRide ?? 0,
                                ),
                              )
                            ]),

                            Row(children: [
                              Expanded(
                                child: Text(
                                  '${levelController.levelModel?.data?.completedCurrentLevelTarget?.
                                  rideCompletePoint?.toInt()} ${'points'.tr}',
                                  style: textBold.copyWith(color: Theme.of(context).primaryColor,
                                    fontSize: Dimensions.fontSizeSmall,
                                  ),
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(
                                    right: Get.find<LocalizationController>().isLtr ?
                                    Get.width * 0.11 : 0,
                                    left: Get.find<LocalizationController>().isLtr ?
                                    0 : Get.width * 0.11
                                ),
                                child: Text(
                                  '${levelController.levelModel?.data?.completedCurrentLevelTarget?.rideComplete?.toInt()}/'
                                      '${levelController.levelModel?.data?.currentLevel?.targetedRide?.toInt()}',
                                  style: textBold.copyWith(color: Theme.of(context).hintColor,
                                    fontSize: Dimensions.fontSizeSmall,
                                  ),
                                ),
                              ),
                            ])
                          ]),
                        ),

                        const SizedBox(height: Dimensions.paddingSizeSmall),
                      ],

                      if((levelController.levelModel?.data?.currentLevel?.targetedReview?.toInt() ?? 0) > 0)...[
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                              border: Border.all(color: Theme.of(context).hintColor.withValues(alpha:0.25))
                          ),
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            TargetNotificationTitle(
                                completedValue: levelController.levelModel?.data?.completedCurrentLevelTarget?.reviewGiven ?? 0,
                                targetValue: levelController.levelModel?.data?.currentLevel?.targetedReview ?? 0
                            ),

                            Text(_targetNotificationSubTitle(
                                levelController.levelModel?.data?.completedCurrentLevelTarget?.reviewGiven ?? 0,
                                levelController.levelModel?.data?.currentLevel?.targetedReview ?? 0
                            ),
                              style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!,
                                fontSize: Dimensions.fontSizeSmall,
                              ),
                            ),

                            const SizedBox(height: Dimensions.paddingSizeDefault),
                            Text('review_given'.tr,
                              style: textBold.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!,
                                fontSize: Dimensions.fontSizeSmall,
                              ),
                            ),

                            Row(children: [
                              Expanded(child: LinearProgressIndicator(
                                value: _calculateProgressValue(
                                  levelController.levelModel?.data?.completedCurrentLevelTarget?.reviewGiven ?? 0,
                                  levelController.levelModel?.data?.currentLevel?.targetedReview ?? 0,
                                ),
                                minHeight: Dimensions.paddingSizeExtraSmall,
                                backgroundColor: Theme.of(context).hintColor.withValues(alpha:0.25),
                              )),

                              Image.asset(height: 30,width: 30,
                                _targetCompleteIcon(
                                  levelController.levelModel?.data?.completedCurrentLevelTarget?.reviewGiven ?? 0,
                                  levelController.levelModel?.data?.currentLevel?.targetedReview ?? 0,
                                ),
                              )
                            ]),

                            Row(children: [
                              Expanded(
                                child: Text(
                                  '${levelController.levelModel?.data?.completedCurrentLevelTarget?.
                                  reviewGivenPoint?.toInt()} ${'points'.tr}',
                                  style: textBold.copyWith(color: Theme.of(context).primaryColor,
                                    fontSize: Dimensions.fontSizeSmall,
                                  ),
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(
                                    right: Get.find<LocalizationController>().isLtr ?
                                    Get.width * 0.11 : 0,
                                    left: Get.find<LocalizationController>().isLtr ?
                                    0 : Get.width * 0.11
                                ),
                                child: Text(
                                  '${levelController.levelModel?.data?.completedCurrentLevelTarget?.reviewGiven?.toInt()}/'
                                      '${levelController.levelModel?.data?.currentLevel?.targetedReview?.toInt()}',
                                  style: textBold.copyWith(color: Theme.of(context).hintColor,
                                    fontSize: Dimensions.fontSizeSmall,
                                  ),
                                ),
                              ),
                            ])
                          ]),
                        ),

                        const SizedBox(height: Dimensions.paddingSizeSmall),
                      ],

                      if((levelController.levelModel?.data?.currentLevel?.targetedAmount?.toInt() ?? 0) > 0)...[
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                              border: Border.all(color: Theme.of(context).hintColor.withValues(alpha:0.25))
                          ),
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            TargetNotificationTitle(
                                completedValue: levelController.levelModel?.data?.completedCurrentLevelTarget?.spendAmount ?? 0,
                                targetValue: levelController.levelModel?.data?.currentLevel?.targetedAmount ?? 0
                            ),

                            Text(_targetNotificationSubTitle(
                                levelController.levelModel?.data?.completedCurrentLevelTarget?.spendAmount ?? 0,
                                levelController.levelModel?.data?.currentLevel?.targetedAmount ?? 0
                            ),
                              style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!,
                                fontSize: Dimensions.fontSizeSmall,
                              ),
                            ),

                            const SizedBox(height: Dimensions.paddingSizeDefault),
                            Text('minimum_spend'.tr,
                              style: textBold.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!,
                                fontSize: Dimensions.fontSizeSmall,
                              ),
                            ),

                            Row(children: [
                              Expanded(child: LinearProgressIndicator(
                                value: _calculateProgressValue(
                                  levelController.levelModel?.data?.completedCurrentLevelTarget?.spendAmount ?? 0,
                                  levelController.levelModel?.data?.currentLevel?.targetedAmount ?? 0,
                                ),
                                minHeight: Dimensions.paddingSizeExtraSmall,
                                backgroundColor: Theme.of(context).hintColor.withValues(alpha:0.25),
                              )),

                              Image.asset(height: 30,width: 30,
                                _targetCompleteIcon(
                                  levelController.levelModel?.data?.completedCurrentLevelTarget?.spendAmount ?? 0,
                                  levelController.levelModel?.data?.currentLevel?.targetedAmount ?? 0,
                                ),
                              )
                            ]),

                            Row(children: [
                              Expanded(
                                child: Text(
                                  '${levelController.levelModel?.data?.completedCurrentLevelTarget?.
                                  spendAmountPoint?.toInt()} ${'points'.tr}',
                                  style: textBold.copyWith(color: Theme.of(context).primaryColor,
                                    fontSize: Dimensions.fontSizeSmall,
                                  ),
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(
                                    right: Get.find<LocalizationController>().isLtr ?
                                    Get.width * 0.11 : 0,
                                    left: Get.find<LocalizationController>().isLtr ?
                                    0 : Get.width * 0.11
                                ),
                                child: Text(
                                  '${PriceConverter.convertPrice(levelController.levelModel?.data?.completedCurrentLevelTarget?.spendAmount ?? 0)}/'
                                      '${PriceConverter.convertPrice(levelController.levelModel?.data?.currentLevel?.targetedAmount ?? 0)}',
                                  style: textRobotoBold.copyWith(color: Theme.of(context).hintColor,
                                    fontSize: Dimensions.fontSizeSmall,
                                  ),
                                ),
                              ),
                            ])
                          ]),
                        ),

                        const SizedBox(height: Dimensions.paddingSizeSmall),
                      ],

                      if((levelController.levelModel?.data?.currentLevel?.targetedCancel?.toInt() ?? 0) > 0)
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                              border: Border.all(color: Theme.of(context).hintColor.withValues(alpha:0.25))
                          ),
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            TargetNotificationTitle(
                                completedValue: levelController.levelModel?.data?.completedCurrentLevelTarget?.cancellationRate ?? 0,
                                targetValue: levelController.levelModel?.data?.currentLevel?.targetedCancel ?? 0
                            ),

                            Text(_targetNotificationSubTitle(
                                levelController.levelModel?.data?.completedCurrentLevelTarget?.cancellationRate ?? 0,
                                levelController.levelModel?.data?.currentLevel?.targetedCancel ?? 0
                            ),
                              style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!,
                                fontSize: Dimensions.fontSizeSmall,
                              ),
                            ),

                            const SizedBox(height: Dimensions.paddingSizeDefault),
                            Text('maximum_cancellation_rate'.tr,
                              style: textBold.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!,
                                fontSize: Dimensions.fontSizeSmall,
                              ),
                            ),

                            Row(children: [
                              Expanded(child: LinearProgressIndicator(
                                value: _calculateProgressValue(
                                  levelController.levelModel?.data?.currentLevel?.targetedCancel ?? 0,
                                  (levelController.levelModel?.data?.completedCurrentLevelTarget?.cancellationRate ?? 0) == 0 ?
                                  1 :
                                  levelController.levelModel?.data?.completedCurrentLevelTarget?.cancellationRate ?? 1,
                                ),
                                minHeight: Dimensions.paddingSizeExtraSmall,
                                backgroundColor: Theme.of(context).hintColor.withValues(alpha:0.25),
                              )),

                              Image.asset(height: 30,width: 30,
                                _targetCompleteIcon(
                                  levelController.levelModel?.data?.completedCurrentLevelTarget?.cancellationRate ?? 0,
                                  levelController.levelModel?.data?.currentLevel?.targetedCancel ?? 0,
                                ),
                              )
                            ]),

                            Row(children: [
                              Expanded(
                                child: Text(
                                  '${levelController.levelModel?.data?.completedCurrentLevelTarget?.
                                  cancellationRatePoint?.toInt()} ${'points'.tr}',
                                  style: textBold.copyWith(color: Theme.of(context).primaryColor,
                                    fontSize: Dimensions.fontSizeSmall,
                                  ),
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(
                                    right: Get.find<LocalizationController>().isLtr ?
                                    Get.width * 0.11 : 0,
                                    left: Get.find<LocalizationController>().isLtr ?
                                    0 : Get.width * 0.11
                                ),
                                child: Text(
                                  '${levelController.levelModel?.data?.completedCurrentLevelTarget?.cancellationRate?.toInt()}/'
                                      '${levelController.levelModel?.data?.currentLevel?.targetedCancel?.toInt()}',
                                  style: textBold.copyWith(color: Theme.of(context).hintColor,
                                    fontSize: Dimensions.fontSizeSmall,
                                  ),
                                ),
                              ),
                            ])
                          ]),
                        )
                    ]),
                  ),
                ) :
                Text('you_reached_the_maximum_level'.tr, style: textBold),
              ]),
            );
          }),
        ),
      ),
    );
  }


  double _calculateTotalTargetPoint(
      double targetedRidePoint,double targetedSpendPoint,
      double targetedCancelPoint, double targetedReviewPoint){
    return (targetedRidePoint + targetedSpendPoint + targetedCancelPoint + targetedReviewPoint);
  }

  double _calculateProgressValue(double completeValue, double targetValue){
    return (1 / targetValue) *completeValue;
  }

  String _targetNotificationSubTitle(double completedValue, double targetValue){
     if(completedValue == 0){
       return 'looks_like_not_start'.tr;
     }else if(completedValue == targetValue){
       return 'you_did_it_high_fives'.tr;
     }else{
       return 'you_are_off_to_a_great_start'.tr;
     }
  }

  String _targetCompleteIcon(double completedValue, double targetValue){
    if(completedValue == targetValue){
      return Images.targetCompleteIcon;
    }else{
      return Images.targetNotCompleteIcon;
    }
  }
}

class TargetNotificationTitle extends StatelessWidget {
  final double completedValue;
  final double targetValue;
  const TargetNotificationTitle({super.key,required this.completedValue,required this.targetValue});

  @override
  Widget build(BuildContext context) {
    return completedValue == 0 ?
    Text('${'oops'.tr}!',
      style: textBold.copyWith(color: Theme.of(context).colorScheme.tertiaryContainer,
        fontSize: Dimensions.fontSizeSmall,
      ),
    ) :
    completedValue == targetValue ?
    Text('${'congrats'.tr}!',
      style: textBold.copyWith(color: Theme.of(context).primaryColor,
        fontSize: Dimensions.fontSizeSmall,
      ),
    ) :
    Text('${'wow'.tr}!',
      style: textBold.copyWith(color: Theme.of(context).colorScheme.inverseSurface,
        fontSize: Dimensions.fontSizeSmall,
      ),
    );
  }

}

