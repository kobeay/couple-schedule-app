import 'package:couple_schedule_app/features/my/data/datasources/my_api.dart';
import 'package:couple_schedule_app/features/my/data/models/user_nickname_update_request.dart';

class MyRepository {
  final MyApi _myApi;

  MyRepository({MyApi? myApi}) : _myApi = myApi ?? MyApi();

  Future<void> updateNickname(UserNicknameUpdateRequest request) {
    return _myApi.updateNickname(request);
  }
}
