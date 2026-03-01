

import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/my_offer/domain/repositories/offer_repository_interface.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class OfferRepository implements OfferRepositoryInterface{
  final ApiClient apiClient;
  OfferRepository({required this.apiClient});

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
  Future getList({int? offset = 1}) async{
    return await apiClient.getData('${AppConstants.bestOfferList}$offset');
  }

  @override
  Future update(value, {int? id}) {
    // TODO: implement update
    throw UnimplementedError();
  }

}