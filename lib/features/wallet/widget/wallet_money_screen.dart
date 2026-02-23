import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/wallet/widget/transaction_card_widget.dart';
import 'package:ride_sharing_user_app/features/wallet/widget/wallet_money_amount_widget.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/features/notification/widgets/notification_shimmer.dart';
import 'package:ride_sharing_user_app/features/wallet/controllers/wallet_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/widget/custom_title.dart';
import 'package:ride_sharing_user_app/common_widgets/no_data_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/paginated_list_widget.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';


class WalletMoneyScreen extends StatefulWidget {
  const WalletMoneyScreen({super.key});
  @override
  State<WalletMoneyScreen> createState() => _WalletMoneyScreenState();
}

class _WalletMoneyScreenState extends State<WalletMoneyScreen> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<WalletController>(builder: (walletController) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: Dimensions.paddingSizeDefault),

        const WalletMoneyAmountWidget(walletMoney: true),

        if(walletController.addFundPromotionalModel?.data != null && walletController.addFundPromotionalModel!.data!.isNotEmpty)...[
          CarouselSlider.builder(
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 2.5,
              enlargeCenterPage: false,
              viewportFraction: 1,
              disableCenter: true,
              autoPlayInterval: const Duration(seconds: 5),
              onPageChanged: (index, reason) {
                activeIndex = index;
                setState(() {
                });
              },
            ),
            itemCount: walletController.addFundPromotionalModel?.data?.length ?? 0,
            itemBuilder: (context, index, _) {
              return InkWell(
                onTap: (){},
                child: Container(
                  padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                  margin: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                      border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.1))
                  ),
                  child: Stack(children: [
                    SizedBox(
                      width: Get.width * 0.7,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(walletController.addFundPromotionalModel?.data?[index].name ?? '', style: textMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        Text('${'valid_till'.tr} ${DateConverter.isoDateTimeStringToDateOnly(walletController.addFundPromotionalModel!.data![index].endDate!)}', style: textMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8), fontSize: Dimensions.fontSizeSmall)),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Text(walletController.addFundPromotionalModel?.data?[index].description ?? '', style: textRegular.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.5),
                          fontSize: Dimensions.fontSizeSmall,
                          overflow: TextOverflow.ellipsis,
                        ), maxLines: 2),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Text(
                          '${'add_fund_to_wallet_and_enjoy'.tr} ${
                              walletController.addFundPromotionalModel?.data?[index].amountType == 'amount' ? 
                              PriceConverter.convertPrice(walletController.addFundPromotionalModel?.data?[index].bonusAmount ?? 0) :
                                  '${walletController.addFundPromotionalModel?.data?[index].bonusAmount}%'
                          } ${'more'.tr}',
                          style: textRegular.copyWith(fontSize: Dimensions.paddingSizeSmall),
                        ),
                      ]),
                    ),

                    Row(children: [
                      Spacer(),

                      Image.asset(Images.addFundBonusImage, height: 100, width: 150)
                    ]),
                  ]),
                ),
              );
            },
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          SizedBox(
            height: 5,width: Get.width,
            child: Center(child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: walletController.addFundPromotionalModel?.data?.length ?? 0,
              itemBuilder: (context,index){
                return Center(child: Container(
                  height: 5,
                  width: index == activeIndex ? 10 : 5,
                  decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(100)),
                ));
              },
              separatorBuilder: (context,index){
                return const Padding(padding: EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall));
              },
            )),
          )
        ],

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: CustomTitle(title: 'wallet_history'.tr,color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8)),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        walletController.transactionModel?.data != null ?
        (walletController.transactionModel!.data!.isNotEmpty) ?
        Expanded(child: SingleChildScrollView(
          controller: Get.find<WalletController>().scrollController,
          child: PaginatedListWidget(
            scrollController: Get.find<WalletController>().scrollController,
            totalSize: walletController.transactionModel!.totalSize,
            offset: (walletController.transactionModel?.offset != null) ? int.parse(walletController.transactionModel!.offset.toString()) : null,
            onPaginate: (int? offset) async {
              await walletController.getTransactionList(offset!);
            },
            itemView: ListView.builder(
              itemCount: walletController.transactionModel!.data!.length,
              padding: const EdgeInsets.all(0),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return TransactionCard(transaction: walletController.transactionModel!.data![index]);
              },
            ),
          ),
        )) :
        const Expanded(child: NoDataWidget(title: 'no_transaction_found')) :
        const Expanded(child: NotificationShimmer()),

      ]);
    });
  }
}

