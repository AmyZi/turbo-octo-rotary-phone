import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/custom_pop_scope_widget.dart';
import 'package:ride_sharing_user_app/features/message/widget/message_bubble.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/message/controllers/message_controller.dart';
import 'package:ride_sharing_user_app/features/notification/widgets/notification_shimmer.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/no_data_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/paginated_list_widget.dart';
import 'dart:math' as math;

class MessageScreen extends StatefulWidget {
  final String channelId;
  final String tripId;
  final String userName;
  const MessageScreen({super.key, required this.channelId, required this.tripId, required this.userName});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future _loadData() async {
    ///make sure to call before getConversation to show loading
    if(Get.find<ProfileController>().profileModel?.data?.id == null) {
      await Get.find<ProfileController>().getProfileInfo();

    }
    Get.find<MessageController>().findChannelRideStatus(widget.channelId);
    Get.find<MessageController>().getConversation(widget.channelId, 1);
    Get.find<MessageController>().subscribeMessageChannel(widget.tripId);
  }


  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: CustomPopScopeWidget(
        child: Scaffold(
          body: BodyWidget(
            appBar: AppBarWidget(
              title:"${'chat_with'.tr} ${widget.userName}", showBackButton: true, centerTitle: true,
            ),
            body:  GetBuilder<MessageController>(builder: (messageController) {
              return Column(children: [
                messageController.messageModel?.data != null ?
                messageController.messageModel!.data!.isNotEmpty ?
                Expanded(child: SingleChildScrollView(
                  controller: scrollController,
                  reverse: true,
                  child: PaginatedListWidget(
                    reverse: true,
                    scrollController: scrollController,
                    totalSize: messageController.messageModel?.totalSize,
                    offset: (messageController.messageModel != null && messageController.messageModel?.offset != null) ?
                    int.parse(messageController.messageModel!.offset.toString()) : null,
                    onPaginate: (int? offset) async {
                      await messageController.getConversation(widget.channelId, offset!);
                    },
                    itemView: ListView.builder(
                      reverse: true,
                      itemCount: messageController.messageModel?.data?.length,
                      padding: const EdgeInsets.all(0),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        if(index != 0){
                          return ConversationBubble(
                            message: messageController.messageModel!.data![index],
                            previousMessage: messageController.messageModel!.data![index-1],
                            index: index,length: messageController.messageModel!.data!.length,
                          );
                        }else{
                          return ConversationBubble(
                            message: messageController.messageModel!.data![index],
                            index: index,length: messageController.messageModel!.data!.length,
                          );
                        }
                      },
                    ),
                  ),
                )) :
                const Expanded(child: NoDataWidget(title: 'no_message_found')) :
                const Expanded(child: NotificationShimmer()),

                (messageController.pickedImageFile != null && messageController.pickedImageFile!.isNotEmpty) ?
                Container(height: 90, width: Get.width,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: messageController.pickedImageFile!.length,
                    itemBuilder: (context, index) {
                      return  Stack(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(height: 80, width: 80, child: Image.file(
                              File(messageController.pickedImageFile![index].path),
                              fit: BoxFit.cover,
                            )),
                          ),
                        ),
                        Positioned(right: 5, child: InkWell(
                          onTap: () => messageController.pickMultipleImage(true,index: index),
                          child: const Icon(Icons.cancel_outlined, color: Colors.red),
                        )),
                      ]);
                    },
                  ),
                ) :
                const SizedBox(),

                messageController.otherFile != null ?
                Stack(children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 25),
                    height: 25, child: Text(messageController.otherFile!.names.toString()),),

                  Positioned(top: 0, right: 0,
                    child: InkWell(
                      onTap: () => messageController.pickOtherFile(true),
                      child: const Icon(Icons.cancel_outlined, color: Colors.red),
                    ),
                  ),
                ]) :
                const SizedBox(),

                ///Message send field here.

                const SizedBox(height: 20),
                messageController.channelRideStatus ?
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Expanded(child: Container(
                    margin: const EdgeInsets.only(
                      left: Dimensions.paddingSizeSmall,
                      right: Dimensions.paddingSizeSmall,
                      bottom: Dimensions.paddingSizeSmall,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor),
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.all(Radius.circular(100)),
                    ),
                    child: Form(
                      key: messageController.conversationKey,
                      child: Row(children: [
                        const SizedBox(width: Dimensions.paddingSizeDefault),

                        Expanded(child: TextField(
                          minLines: 1,
                          controller: messageController.conversationController,
                          textCapitalization: TextCapitalization.sentences,
                          style: textMedium.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color:Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8),
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: 2,
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "type_here".tr,
                            hintStyle: textRegular.copyWith(
                              color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha:0.8),
                              fontSize: 16,
                            ),
                          ),
                          onChanged: (String newText) {},
                        )),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                          child: InkWell(
                            onTap: () => messageController.pickMultipleImage(false),
                            child: Image.asset(
                              Images.pickImage, color: Get.isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ]),
                    ),
                  )),

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor),
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                    ),
                    margin: EdgeInsets.only(
                      bottom: Dimensions.paddingSizeDefault,
                      right: Get.find<LocalizationController>().isLtr ? Dimensions.paddingSizeDefault : 0,
                      left: Get.find<LocalizationController>().isLtr ? 0 : Dimensions.paddingSizeDefault,
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: messageController.isSending ?
                    SpinKitCircle(color: Theme.of(context).cardColor, size: 20) :
                    messageController.isImagePicked ?
                    SpinKitCircle(color: Theme.of(context).cardColor, size: 20) :
                    InkWell(
                      onTap: (){
                        if(messageController.conversationController.text.trim().isEmpty
                            && messageController.pickedImageFile!.isEmpty
                            && messageController.otherFile==null) {
                          showCustomSnackBar('write_something'.tr, isError: true);
                        } else if(messageController.conversationKey.currentState!.validate()) {
                          messageController.sendMessage(widget.channelId , widget.tripId).then((value) {
                          });
                        }
                        messageController.conversationController.clear();
                      },
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Get.find<LocalizationController>().isLtr ?
                        Matrix4.rotationY(0) :
                        Matrix4.rotationY(math.pi),
                        child: Image.asset(
                          Images.sendMessage,
                          width: Dimensions.iconSizeMedium,
                          height: Dimensions.iconSizeMedium,
                          color: Theme.of(context).cardColor,
                        ),
                      ),
                    ),
                  )
                ]) :
                SizedBox(height: 50, child: Container(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha:0.75), borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(Icons.block),
                    const SizedBox(width: 5),

                    Flexible(child: Text("you_could't_replay_you_have_no_trip".tr)),
                  ]),
                )),

              ]);
            }),
          ),
        ),
      ),
    );
  }
}
