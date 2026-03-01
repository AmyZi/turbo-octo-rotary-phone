import 'package:file_picker/file_picker.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/message/domain/repositories/message_repository_interface.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';



class MessageRepository implements MessageRepositoryInterface{
  final ApiClient apiClient;
  MessageRepository({required this.apiClient});

  @override
  Future<Response> createChannel(String userId,String tripId) async {
    return await apiClient.postData(AppConstants.createChannel,
        {
          "to": userId,
          "trip_id": tripId,
          "_method": "put"
        });
  }

  @override
  Future<Response> getChannelList(int offset) async {
    return await apiClient.getData('${AppConstants.channelList}?limit=10&offset=$offset');
  }


  @override
  Future<Response> getConversation(String channelId,int offset) async {
    return await apiClient.getData('${AppConstants.conversationList}?channel_id=$channelId&limit=10&offset=$offset');
  }

  @override
  Future<Response> sendMessage(String message,String channelID, String tripId, List<MultipartBody> file, PlatformFile? platformFile) async {

    return await apiClient.postMultipartDataConversation(
        AppConstants.sendMessage,
        {
          "message": message,
          "channel_id" : channelID,
          "trip_id" : tripId,
          "_method":"put"
        },
        file ,
        otherFile: platformFile
    );
  }

  @override
  Future<Response> findChannelRideStatus(String channelId) async{
    return await apiClient.getData('${AppConstants.findChannelRideStatus}?channel_id=$channelId');
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset = 1}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(value, {int? id}) {
    // TODO: implement update
    throw UnimplementedError();
  }
}