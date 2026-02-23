import 'package:ride_sharing_user_app/features/splash/domain/repositories/config_repository_interface.dart';
import 'package:ride_sharing_user_app/features/splash/domain/services/config_service_interface.dart';

class ConfigService implements ConfigServiceInterface{
  ConfigRepositoryInterface configRepositoryInterface;

  ConfigService({required this.configRepositoryInterface});

  @override
  void disableIntro() {
    configRepositoryInterface.disableIntro();
  }

  @override
  Future getConfigData() {
    return configRepositoryInterface.getConfigData();
  }

  @override
  Future<bool> initSharedData() {
    return configRepositoryInterface.initSharedData();
  }

  @override
  Future<bool> removeSharedData() {
    return configRepositoryInterface.removeSharedData();
  }

  @override
  bool? showIntro() {
    return configRepositoryInterface.showIntro();
  }

  @override
  bool haveOngoingRides() {
    return configRepositoryInterface.haveOngoingRides();
  }

  @override
  void saveOngoingRides(bool value) {
    return configRepositoryInterface.saveOngoingRides(value);
  }



}