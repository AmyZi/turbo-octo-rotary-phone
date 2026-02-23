import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/wallet/controllers/wallet_controller.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/models/transaction_model.dart';
import 'package:ride_sharing_user_app/common_widgets/divider_widget.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault),
      child: GetBuilder<WalletController>(
          builder: (walletController) {
            return Column(children: [
              Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                child: Row(children: [
                  Image.asset(
                    Images.myEarnIcon,
                    height: Dimensions.paddingSizeExtraLarge,
                    width: Dimensions.paddingSizeExtraLarge,
                  ),

                  Expanded(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        transaction.attribute!.tr,
                        style: textBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                        child: Text(DateConverter.isoStringToDateTimeString(transaction.createdAt ?? ''),
                            style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8), fontSize: Dimensions.fontSizeExtraSmall)),
                      ),
                    ])),
                  ])),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault,
                      vertical: Dimensions.paddingSizeSeven,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Theme.of(context).hintColor.withValues(alpha:0.15),
                    ),
                    child: Text(
                      '${transaction.debit! > 0 ? '-' : '+'} ${PriceConverter.convertPrice(transaction.debit! > 0 ?
                      transaction.debit! :
                      transaction.credit!)}',
                      style: textRobotoBold,
                    ),
                  ),

                ]),
              ),

              CustomDivider(height: .5,color: Theme.of(context).hintColor.withValues(alpha:0.75)),

            ]);
          }
      ),
    );
  }
}
