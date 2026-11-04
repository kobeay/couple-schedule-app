import 'package:couple_schedule_app/features/couple/data/models/couple_invitation_request.dart';
import 'package:couple_schedule_app/features/couple/presentation/providers/couple_invitation_notifier.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:couple_schedule_app/app/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';

class CoupleInvitationPage extends ConsumerStatefulWidget {
  const CoupleInvitationPage({super.key});

  @override
  ConsumerState<CoupleInvitationPage> createState() =>
      _CoupleInvitationPageState();
}

class _CoupleInvitationPageState extends ConsumerState<CoupleInvitationPage> {
  final TextEditingController _inviteCodeController = TextEditingController();

  bool _isInviteCodeValid = false;

  @override
  void dispose() {
    _inviteCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final invitationState = ref.watch(coupleInvitationProvider);

    ref.listen(coupleInvitationProvider, (previous, next) {
      if (previous?.isLoading == true && next is AsyncData) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('초대 요청을 보냈습니다.')));

        return;
      }

      if (next is AsyncError) {
        final error = next.error;

        String errorMessage = '초대 코드 요청 중 오류가 발생했습니다.';

        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.connectionTimeout:
            case DioExceptionType.sendTimeout:
            case DioExceptionType.receiveTimeout:
              errorMessage = '요청 시간이 초과되었습니다. 다시 시도해 주세요.';
              break;

            case DioExceptionType.connectionError:
              errorMessage = '서버에 연결할 수 없습니다. 인터넷 연결과 서버 상태를 확인해 주세요.';
              break;

            case DioExceptionType.badResponse:
              final statusCode = error.response?.statusCode;

              if (statusCode != null && statusCode >= 500) {
                errorMessage = '서버에 문제가 발생했습니다. 잠시 후 다시 시도해 주세요.';
              } else if (statusCode == 400) {
                final responseData = error.response?.data;

                if (responseData == '존재하지 않는 초대 코드입니다.') {
                  errorMessage = '존재하지 않는 초대 코드입니다.';
                } else if (responseData == '이미 초대 요청을 보냈습니다.') {
                  errorMessage = '이미 초대 요청을 보냈습니다.';
                } else {
                  errorMessage = '초대 요청을 처리할 수 없습니다.';
                }
              }
              break;

            default:
              break;
          }
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('커플 초대 요청'),
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(CupertinoIcons.chevron_left),
          color: AppColors.textIcon,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(
                          CupertinoIcons.heart,
                          size: 40,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '상대방의 초대 코드를 입력해 주세요',
                          textAlign: TextAlign.center,
                          style: textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '초대 요청을 보내고 상대방이 수락하면\n커플 연결이 완료돼요!',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text('상대방 초대 코드', style: textTheme.titleSmall),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _inviteCodeController,
                          keyboardType: TextInputType.visiblePassword,
                          maxLength: 8,
                          onChanged: (value) {
                            setState(() {
                              _isInviteCodeValid = value.length == 8;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: '상대방 초대 코드 입력',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                FilledButton(
                  onPressed: _isInviteCodeValid && !invitationState.isLoading
                      ? () {
                          final request = CoupleInvitationRequest(
                            inviteCode: _inviteCodeController.text,
                          );

                          ref
                              .read(coupleInvitationProvider.notifier)
                              .sendInvitation(request);
                        }
                      : null,
                  child: invitationState.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('초대 요청 보내기'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
