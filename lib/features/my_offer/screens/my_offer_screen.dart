import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/paginated_list_widget.dart';
import 'package:ride_sharing_user_app/features/coupon/controllers/coupon_controller.dart';
import 'package:ride_sharing_user_app/features/coupon/widget/offer_coupon_card_widget.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/home/controllers/category_controller.dart';
import 'package:ride_sharing_user_app/features/my_offer/controller/offer_controller.dart';
import 'package:ride_sharing_user_app/features/my_offer/screens/discount_screen.dart';
import 'package:ride_sharing_user_app/features/my_offer/widgets/discount_cart_widget.dart';
import 'package:ride_sharing_user_app/features/my_offer/widgets/no_coupon_widget.dart';
import 'package:ride_sharing_user_app/features/my_offer/widgets/offer_type_button_widget.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class MyOfferScreen extends StatefulWidget {
  final bool fromDashboard;
  final bool isCoupon;
  const MyOfferScreen({super.key, this.isCoupon = false, this.fromDashboard = false});

  @override
  State<MyOfferScreen> createState() => _MyOfferScreenState();
}

class _MyOfferScreenState extends State<MyOfferScreen> {
  final ScrollController scrollController = ScrollController();
  final OfferController offerController = Get.find<OfferController>();

  @override
  void initState() {
    if(widget.isCoupon){
      offerController.setCurrentTabIndex(1, isUpdate: false);
    }else{
      offerController.setCurrentTabIndex(0, isUpdate: false);
    }

    if(offerController.bestOfferModel == null){
      offerController.getOfferList(1);
    }
    Get.find<CategoryController>().setCouponFilterIndex(0,isUpdate: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (res,val){
          _onPopScopePress(res);
        },
        child: Scaffold(
        body: GetBuilder<OfferController>(builder: (offerController){
          return Stack(children: [
            BodyWidget(
              appBar: AppBarWidget(
                title: 'my_offer'.tr, showDiscountHint: offerController.currentTabIndex == 0 ? true : false , centerTitle: true,
                onBackPressed: (){
                  _onBackPress();
                },
              ),
              body: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const SizedBox(height: Dimensions.paddingSizeSignUp),

                    if(offerController.currentTabIndex == 1)...[
                      Text('available_coupon'.tr, style: textSemiBold),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      _CategoryList()
                    ],

                    Expanded(child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(children: [
                        !(offerController.currentTabIndex == 1) ?
                        GetBuilder<OfferController>(builder: (offerController){
                          return (offerController.bestOfferModel!.data!= null && offerController.bestOfferModel!.data!.isNotEmpty) ?
                          PaginatedListWidget(
                            scrollController: scrollController,
                            onPaginate: (int? offset) async {
                              await offerController.getOfferList(offset!);
                            },
                            totalSize: offerController.bestOfferModel?.totalSize,
                            offset: int.parse(offerController.bestOfferModel!.offset.toString()),
                            itemView: ListView.separated(
                              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                              itemCount: offerController.bestOfferModel!.data!.length,
                              itemBuilder: (context, index){
                                return InkWell(
                                  onTap: (){
                                    Get.to(()=>  DiscountScreen(offerModel: offerController.bestOfferModel!.data![index]));
                                  },

                                  child: DiscountCartWidget(offerModel: offerController.bestOfferModel!.data![index]),
                                );
                              },
                              separatorBuilder: (context, index){
                                return const SizedBox(height: Dimensions.paddingSizeDefault);
                              },
                            ),
                          ) :
                          NoCouponWidget(
                            title: 'no_discount_found'.tr,
                            description: 'sorry_there_is_no_discount'.tr,
                          );
                        }) :
                        GetBuilder<CouponController>(builder: (couponController){
                          return (couponController.couponModel!.data != null && couponController.couponModel!.data!.isNotEmpty) ?
                          PaginatedListWidget(
                            scrollController: scrollController,
                            onPaginate: (int? offset) async {
                              await couponController.getCouponList(offset!);
                            },
                            totalSize: couponController.couponModel?.totalSize,
                            offset: int.parse(couponController.couponModel!.offset.toString()),
                            itemView:  ListView.separated(shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                              itemCount: couponController.couponModel!.data!.length,
                              itemBuilder: (context, index){
                                return OfferCouponCardWidget(
                                  fromCouponScree: true,
                                  coupon: couponController.couponModel!.data![index],
                                  index: index,
                                );
                              },
                              separatorBuilder: (context, index){
                                return const SizedBox(height: Dimensions.paddingSizeDefault);
                              },
                            ),
                          ) :
                          NoCouponWidget(
                            title: 'no_coupon_available'.tr,
                            description: 'sorry_there_is_no_coupon'.tr,
                          );
                        })
                      ]),
                    ))
                  ])
              ),
            ),

            Positioned(top: Get.height * (GetPlatform.isIOS ? 0.15 :  0.11), left: Dimensions.paddingSizeSmall,
              child: SizedBox(height: Get.find<LocalizationController>().isLtr? 45 : 50,
                width: Get.width-Dimensions.paddingSizeDefault,
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  itemCount: offerController.offerType.length,
                  itemBuilder: (context, index){
                    return SizedBox(width: Get.width/2.2, child: OfferTypeButtonWidget(
                      offerTypeName : offerController.offerType[index], index: index,
                    ));
                  },
                ),
              ),
            ),
          ]);
        })
        ),
      ),
    );
  }

  void _onPopScopePress(bool res){
    if(widget.fromDashboard){
      Get.back();
    }else{
      if(offerController.currentTabIndex == 1){
        offerController.setCurrentTabIndex(0);
      }else{
        if(!res){
          if(Navigator.canPop(context)){
            Get.back();
          }else{
            Get.offAll(()=> const DashboardScreen());
          }
        }
      }
    }
  }

  void _onBackPress(){
    if(widget.fromDashboard){
      Get.back();
    }else{
      if(offerController.currentTabIndex == 1){
        offerController.setCurrentTabIndex(0);
      }else{
        if(Navigator.canPop(context)){
          Get.back();
        }else{
          Get.offAll(()=> const DashboardScreen());
        }
      }
    }

  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (categoryController){
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 30),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: (categoryController.categoryList?.length ?? 0) + 2,
          itemBuilder: (context, index){
            return InkWell(
              onTap: ()=> categoryController.setCouponFilterIndex(index),
              child: Container(
                decoration: BoxDecoration(
                    color:
                    categoryController.couponFilterIndex == index ?
                    Theme.of(context).primaryColor :
                    Theme.of(context).hintColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(50)
                ),
                padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                child: Center(child: Text(
                  index == 0 ? 'all_coupons'.tr :
                  index == 1 ?
                  'parcel'.tr :
                  categoryController.categoryList?[index - 2].name ?? '',
                  style: textRegular.copyWith(color: categoryController.couponFilterIndex == index ? Theme.of(context).cardColor : null),
                )),
              ),
            );
          },
          separatorBuilder: (ctx, index){
            return const SizedBox(width: Dimensions.paddingSizeSmall);
          },
        ),
      );
    });
  }
}

