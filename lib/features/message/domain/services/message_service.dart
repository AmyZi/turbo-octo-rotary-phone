import 'package:file_picker/file_picker.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/message/domain/repositories/message_repository_interface.dart';
import 'package:ride_sharing_user_app/features/message/domain/services/message_service_interface.dart';

class MessageService implements MessageServiceInterface{
  MessageRepositoryInterface messageRepositoryInterface;

  MessageService({required this.messageRepositoryInterface});

  @override
  Future createChannel(String userId, String tripId) async{
    return await messageRepositoryInterface.createChannel(userId,tripId);
  }

  @override
  Future getChannelList(int offset) async{
    return await messageRepositoryInterface.getChannelList(offset);
  }

  @override
  Future getConversation(String channelId, int offset) async{
    return await messageRepositoryInterface.getConversation(channelId, offset);
  }

  @override
  Future<Response> sendMessage(String message, String channelID, String tripId, List<MultipartBody> file, PlatformFile? platformFile) async{
    return await messageRepositoryInterface.sendMessage(message, channelID, tripId, file, platformFile);
  }

  @override
  Future findChannelRideStatus(String channelId) {
    return messageRepositoryInterface.findChannelRideStatus(channelId);
  }

}