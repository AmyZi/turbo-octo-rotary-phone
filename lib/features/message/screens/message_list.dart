import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/message/controllers/message_controller.dart';
import 'package:ride_sharing_user_app/features/message/domain/models/channel_model.dart';
import 'package:ride_sharing_user_app/features/message/widget/message_item.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/features/notification/widgets/notification_shimmer.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/no_data_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/paginated_list_widget.dart';

class MessageListScreen extends StatefulWidget {
  const MessageListScreen({super.key});

  @override
  State<MessageListScreen> createState() => _MessageListScreenState();
}

class _MessageListScreenState extends State<MessageListScreen> {
  ScrollController scrollController = ScrollController();


  @override
  void initState() {
    Get.find<MessageController>().getChannelList(1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: BodyWidget(
          appBar: AppBarWidget(title: 'message'.tr,showBackButton: true,),
          body: GetBuilder<MessageController>(builder: (messageController) {
            return Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault), child: Column(children:  [

             // const SearchWidget(),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              (messageController.channelModel?.data != null) ? messageController.channelModel!.data!.isNotEmpty ? Expanded(child: SingleChildScrollView(
                controller: scrollController,
                child: PaginatedListWidget(reverse: true,
                  scrollController: scrollController,
                  totalSize: messageController.channelModel!.totalSize,
                  offset: messageController.channelModel != null && messageController.channelModel!.offset != null? int.parse(messageController.channelModel!.offset.toString()) : 1,
                  onPaginate: (int? offset) async {
                    await messageController.getChannelList(offset!);
                  },
                  itemView: ListView.builder(itemCount: messageController.channelModel!.data!.length,
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      ChannelUsers? channelUser;
                      for (var element in messageController.channelModel!.data![index].channelUsers!) {
                        if(element.user?.userType == 'driver') {
                          channelUser = element;
                        }
                      }

                      return messageController.channelModel!.data![index].lastChannelConversations != null ? MessageItem(
                        isRead: false, channelUsers: channelUser,unReadCount: messageController.channelModel!.data![index].unReadCount!,
                        lastMessage: messageController.channelModel!.data![index].lastChannelConversations?.message ?? '', tripId: messageController.channelModel!.data![index].tripId!,
                      ) : const SizedBox();
                    },
                  ),
                ),
              )) : const Expanded(child: NoDataWidget(title: 'no_chat_found')) : const Expanded(child: NotificationShimmer()),

            ]));
          }),
        ),
      ),
    );
  }
}
