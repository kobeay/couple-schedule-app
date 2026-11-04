import 'package:couple_schedule_app/core/network/dio_client.dart';
import 'package:couple_schedule_app/features/couple/data/models/couple_invitation_request.dart';
import 'package:couple_schedule_app/features/couple/data/models/couple_invitation_response.dart';
import 'package:couple_schedule_app/features/couple/data/models/couple_response.dart';
import 'package:dio/dio.dart';

class CoupleApi {
  final Dio _dio;

  CoupleApi({Dio? dio}) : _dio = dio ?? DioClient.dio;

  Future<CoupleResponse> getMyCouple() async {
    final response = await _dio.get('/api/couples/me');

    return CoupleResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> sendInvitation(CoupleInvitationRequest request) async {
    await _dio.post('/api/couples/invitations', data: request.toJson());
  }

  Future<List<CoupleInvitationResponse>> getReceivedInvitations() async {
    final response = await _dio.get('/api/couples/invitations/received');

    final List<dynamic> data = response.data as List<dynamic>;

    return data
        .map(
          (json) =>
              CoupleInvitationResponse.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> acceptInvitation(int invitationId) async {
    await _dio.post('/api/couples/invitations/$invitationId/accept');
  }

  Future<void> rejectInvitation(int invitationId) async {
    await _dio.post('/api/couples/invitations/$invitationId/reject');
  }

  Future<void> disconnectCouple() async {
    await _dio.delete('/api/couples/me');
  }
}
