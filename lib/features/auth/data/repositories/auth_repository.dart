import 'package:couple_schedule_app/features/auth/data/datasources/auth_api.dart';
import 'package:couple_schedule_app/features/auth/data/models/sign_up_request.dart';

class AuthRepository {
  final AuthApi _authApi;

  AuthRepository({AuthApi? authApi}) : _authApi = authApi ?? AuthApi();

  Future<void> signUp(SignUpRequest request) async {
    await _authApi.signUp(request);
  }
}
