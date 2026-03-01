import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/features/refund_request/controllers/refund_request_controller.dart';
import 'package:ride_sharing_user_app/features/refund_request/screens/image_video_viewer.dart';
import 'package:ride_sharing_user_app/features/refund_request/widgets/pick_button_widget.dart';
import 'package:ride_sharing_user_app/features/settings/domain/html_enum_types.dart';
import 'package:ride_sharing_user_app/features/settings/screens/policy_screen.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class RefundRequestScreen extends StatefulWidget {
  final String tripId;
  const RefundRequestScreen({super.key,required this.tripId});

  @override
  State<RefundRequestScreen> createState() => _RefundRequestScreenState();
}

class _RefundRequestScreenState extends State<RefundRequestScreen> {

  final TextEditingController productApproximatePriceController = TextEditingController();
  final TextEditingController refundNoteTextController = TextEditingController();

  @override
  void initState() {
    Get.find<RefundRequestController>().onClearRefundData();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: BodyWidget(
          appBar: AppBarWidget(title: 'refund_request'.tr,showBackButton: true,centerTitle: true),
          body: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: GetBuilder<RefundRequestController>(builder: (refundRequestController){
              return SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('select_refund_reason'.tr,style: textBold),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: refundRequestController.refundReasonModel?.data?.length,
                    itemBuilder: (context,index){
                      return Column(children: [
                        InkWell(
                          onTap: ()=> refundRequestController.setParcelRefundCurrentIndex(index),
                          child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                            Expanded(child: Text(
                              refundRequestController.refundReasonModel?.data?[index] ?? '',
                              style: TextStyle(
                                color: !(refundRequestController.parcelRefundReasonCauseCurrentIndex == index) ?
                                Theme.of(context).hintColor :
                                Theme.of(context).textTheme.bodyMedium!.color,
                                fontWeight: FontWeight.w400,fontSize: Dimensions.fontSizeDefault,
                              ),
                            )),

                            refundRequestController.parcelRefundReasonCauseCurrentIndex == index ?
                            Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
                              ),
                              child: const Icon(Icons.check, color: Colors.white,size: 16),
                            ) :
                            Container(
                              height: 16,width: 16,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                                border: Border.all(color: Theme.of(context).hintColor),
                              ),
                              child: const SizedBox(),
                            ),
                            const SizedBox(width: 8),
                          ]),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall)
                      ]);
                    },
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Text('customer_note'.tr,style: textBold),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  SizedBox(height: 80,
                    child: TextField(
                      cursorColor: Theme.of(context).primaryColor,
                      maxLength: 250,
                       controller: refundNoteTextController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                          borderSide: BorderSide(width: 0.5, color: Theme.of(context).primaryColor.withValues(alpha:0.5)),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                          borderSide: BorderSide(width: 0.5, color: Theme.of(context).primaryColor.withValues(alpha:0.5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                          borderSide: BorderSide(width: 0.5, color: Theme.of(context).primaryColor.withValues(alpha:0.5)),
                        ),
                          hintText: 'type_here_your_refund_reason'.tr,
                          hintStyle: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0)
                      ),
                      maxLines: 2,
                    style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Text(
                    '${'product_approximate_price'.tr} (${Get.find<ConfigController>().config?.currencySymbol ?? ''})',
                    style: textRobotoBold,
                  ),

                  Text('please_enter_the_product_price_to_make_it'.tr),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  SizedBox(height: 40,
                    child: TextField(
                       controller: productApproximatePriceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                          borderSide: BorderSide(width: 0.5, color: Theme.of(context).primaryColor.withValues(alpha:0.5)),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                          borderSide: BorderSide(width: 0.5, color: Theme.of(context).primaryColor.withValues(alpha:0.5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                          borderSide: BorderSide(width: 0.5, color: Theme.of(context).primaryColor.withValues(alpha:0.5)),
                        ),
                        hintText: 'Ex: 50',
                        hintStyle: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0)
                      ),
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Text('give_proof'.tr,style: textBold),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  GridView.builder(
                      shrinkWrap: true,
                      itemCount:  math.min(refundRequestController.proofImages.length + 1, 5),
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // number of items in each row
                          mainAxisSpacing: Dimensions.paddingSizeSmall, // spacing between rows
                          crossAxisSpacing: Dimensions.paddingSizeSmall,
                          childAspectRatio: 1.5// spacing between columns
                      ),
                      itemBuilder: (context, index){
                        if(index == refundRequestController.proofImages.length){
                          return Stack(children: [
                            InkWell(
                              onTap: (){
                                Get.bottomSheet(
                                  backgroundColor: Theme.of(context).cardColor,
                                    const PickImageBottomSheet()
                                );
                              },
                              child: Container(height: 100,width: 150,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.secondaryFixedDim.withValues(alpha:0.05),
                                    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault))
                                ),
                                child: Column(crossAxisAlignment:CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Image.asset(Images.pickImageIcon,height: 24,width: 24,color: Theme.of(context).textTheme.bodyMedium!.color),
                                  const SizedBox(height: Dimensions.paddingSizeSmall),

                                  Text(refundRequestController.proofImages.isEmpty ? 'upload_media'.tr : 'add_more'.tr,style: textRegular)
                                ]),
                              ),
                            ),
                          ]);
                        }else{
                          return Stack(children: [
                            InkWell(
                              onTap: ()=> Get.to(()=> ImageVideoViewer(proofImages: refundRequestController.proofImages,clickedIndex: index)),
                              child: Container(height: 100,width: 150,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.secondaryFixedDim.withValues(alpha:0.05),
                                    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault))
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                                  child: Image.file(
                                    refundRequestController.proofImages[index].path.contains('.mp4') ?
                                    File(refundRequestController.thumbnailPaths[index]) :
                                    File(refundRequestController.proofImages[index].path),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),

                            if(refundRequestController.proofImages[index].path.contains('.mp4'))
                            InkWell(
                              onTap: ()=> Get.to(()=> ImageVideoViewer(proofImages: refundRequestController.proofImages,clickedIndex: index)),
                              child: Center(child: Image.asset(Images.playButtonIcon)),
                            ),

                            Container(
                              transform: Matrix4.translationValues(0, -5, 0),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  onTap:()=> refundRequestController.removeImage(index),
                                  child: Container(
                                    height: 20,width: 20,
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).colorScheme.error,
                                    ),
                                    child: Image.asset(Images.crossIcon,color: Theme.of(context).cardColor),
                                  ),
                                ),
                              ),
                            ),
                          ]);
                        }
                      }

                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Text('instruction'.tr,style: textBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('1. ',style: textRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8)
                    )),

                    Expanded(
                      child: RichText(text: TextSpan(
                          text: '${'please_read_our'.tr} ',
                          style: textRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8)
                          ),
                          children: [
                            TextSpan(
                              text: 'refund_policy'.tr,
                              style: textSemiBold.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  decoration: TextDecoration.underline,
                                  color: Theme.of(context).colorScheme.surfaceContainer
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () => Get.to(()=> PolicyScreen(
                                  htmlType: HtmlType.refundPolicy,
                                image: Get.find<ConfigController>().config?.refundPolicy?.image??'',
                              )),
                            ),
                            TextSpan(
                              text: ' ${'before_submit_refund_request'.tr}',
                              style: textRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8)
                              ),
                            )
                          ]
                      )),
                    ),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('2. ',style: textRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8)
                    )),

                    Expanded(
                      child: Text('upload_clear_view_of_image_or_video'.tr,style: textRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8)
                      )),
                    )
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('3. ',style: textRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8)
                    )),

                    RichText(text: TextSpan(
                        text: 'upload_image_within'.tr,
                        style: textRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8)
                        ),
                        children: [
                          TextSpan(
                            text: ' 2mb'.tr,
                            style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                          )
                        ]
                    )),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('4. ',style: textRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8)
                    )),

                    RichText(text: TextSpan(
                        text: 'upload_video_within'.tr,
                        style: textRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8)
                        ),
                        children: [
                          TextSpan(
                            text: ' 10mb ',
                            style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                          ),
                          TextSpan(
                            text: 'video_length_max'.tr,
                            style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                          ),
                          TextSpan(
                            text: ' 2min',
                            style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                          )
                        ]
                    )),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('5. ',style: textRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8)
                    )),

                    Expanded(
                      child: Text('video_must_be_mp4'.tr,style: textRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8)
                      )),
                    )
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeOverLarge),

                  refundRequestController.isLoading ?
                  SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0) :
                  Row(children:  [
                    Expanded(
                      child: ButtonWidget(
                        backgroundColor: Theme.of(context).cardColor,
                        textColor: Theme.of(context).primaryColor,
                        showBorder: true,
                        buttonText: 'cancel'.tr,
                        onPressed: ()=> Get.back(),
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Expanded(child: ButtonWidget(
                      buttonText: 'submit'.tr,
                      onPressed: ()=> _onSubmit(),
                    ))
                  ])

                ]),
              );
            }),
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    final refundRequestController = Get.find<RefundRequestController>();

    String refundReason =
    refundRequestController.refundReasonModel?.data != null ? refundRequestController.refundReasonModel!.data!.isNotEmpty ?
    (refundRequestController.refundReasonModel?.data?[refundRequestController.parcelRefundReasonCauseCurrentIndex] ?? '') : '' : '';
    String refundNote = refundNoteTextController.text;

    if(productApproximatePriceController.text.trim().isEmpty){
      showCustomSnackBar('product_approximate_price_required'.tr);

    }else if(refundRequestController.proofImages.isEmpty){
      showCustomSnackBar('proof_required'.tr);

    }else{
      refundRequestController.sendRefundRequest(
        tripId: widget.tripId,
        refundReason:  refundReason,
        refundNote: refundNote,
        productApproximatePrice: double.parse(productApproximatePriceController.text),
      );
    }
  }
}

class PickImageBottomSheet extends StatelessWidget {
  const PickImageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        InkWell(
          onTap: ()=> Get.back(),
          child: Align(alignment: Alignment.topRight,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha:0.2),
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),

              child: Image.asset(Images.crossIcon,height: 10,width: 10,color: Theme.of(context).textTheme.bodyMedium!.color),
            ),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Text('give_refund_proof'.tr,style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          PickButtonWidget(
            onTap: ()=> Get.find<RefundRequestController>().pickProofImage(ImageSource.gallery,false),
            title: 'gallery_image'.tr,
            image: Images.galleryImageIcon,
          ),

          PickButtonWidget(
            onTap: ()=> Get.find<RefundRequestController>().pickProofImage(ImageSource.camera,false),
            title: 'capture_image'.tr,
            image: Images.cameraImageIcon,
          ),
        ]),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        SizedBox(width: Get.width * 0.5, child: Divider(color: Theme.of(context).hintColor.withValues(alpha:0.5))),
        const SizedBox(height: Dimensions.paddingSizeSmall),


        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          PickButtonWidget(
            onTap: ()=> Get.find<RefundRequestController>().pickProofImage(ImageSource.gallery,true),
            title: 'gallery_video'.tr,
            image: Images.galleryVideoIcon,
          ),

          PickButtonWidget(
            onTap: ()=> Get.find<RefundRequestController>().pickProofImage(ImageSource.camera,true),
            title: 'record_video'.tr,
            image: Images.cameraVideoIcon,
          ),
        ]),
        const SizedBox(height: Dimensions.paddingSizeSmall)
      ]),
    );
  }
}


