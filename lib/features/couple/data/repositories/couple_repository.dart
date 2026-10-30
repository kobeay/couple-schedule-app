import 'package:couple_schedule_app/features/couple/data/datasources/couple_api.dart';
import 'package:couple_schedule_app/features/couple/data/models/couple_response.dart';

class CoupleRepository {
  final CoupleApi _coupleApi;

  CoupleRepository({CoupleApi? coupleApi})
    : _coupleApi = coupleApi ?? CoupleApi();

  Future<CoupleResponse> getMyCouple() {
    return _coupleApi.getMyCouple();
  }
}
