import 'package:file_picker/file_picker.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:get/get_connect/http/src/response/response.dart';

abstract class MessageServiceInterface{
  Future<dynamic> createChannel(String userId, String tripId);
  Future<dynamic> getChannelList(int offset);
  Future<dynamic> getConversation(String channelId,int offset);
  Future<Response> sendMessage(String message,String channelID, String tripId, List<MultipartBody> file, PlatformFile? platformFile);
  Future<dynamic> findChannelRideStatus(String channelId);

}