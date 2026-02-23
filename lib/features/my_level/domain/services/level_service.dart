

import 'package:ride_sharing_user_app/features/my_level/domain/repositories/level_repository_interface.dart';
import 'package:ride_sharing_user_app/features/my_level/domain/services/level_service_interface.dart';

class LevelService implements LevelServiceInterface{
  final LevelRepositoryInterface levelRepositoryInterface;
  LevelService({required this.levelRepositoryInterface});

  @override
  Future getProfileLevelInfo() {
    return levelRepositoryInterface.getProfileLevelInfo();
  }

}