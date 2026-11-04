import 'package:couple_schedule_app/app/theme/app_colors.dart';
import 'package:couple_schedule_app/features/auth/presentation/providers/user_info_provider.dart';
import 'package:couple_schedule_app/features/couple/presentation/pages/couple_invitation_page.dart';
import 'package:couple_schedule_app/features/couple/presentation/providers/couple_disconnection_notifier.dart';
import 'package:couple_schedule_app/features/couple/presentation/providers/couple_invitation_action_notifier.dart';
import 'package:couple_schedule_app/features/couple/presentation/providers/couple_provider.dart';
import 'package:couple_schedule_app/features/couple/presentation/providers/received_invitations_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CoupleManagementPage extends ConsumerStatefulWidget {
  const CoupleManagementPage({super.key});

  @override
  ConsumerState<CoupleManagementPage> createState() =>
      _CoupleManagementPageState();
}

class _CoupleManagementPageState extends ConsumerState<CoupleManagementPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final userInfo = ref.watch(userInfoProvider);
    final coupleInfo = ref.watch(coupleProvider);
    final receivedInvitaions = ref.watch(receivedInvitaionsProvider);
    final invitationActionState = ref.watch(coupleInvitationActionProvider);
    final disconnectionState = ref.watch(coupleDisconnectionNotifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('커플 연결 관리'),
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(CupertinoIcons.chevron_left),
          color: AppColors.textIcon,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                coupleInfo.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => const Text('커플 정보를 불러오지 못했어요'),
                  data: (couple) {
                    final nickname = couple.partnerNickname ?? '상대방';

                    if (!couple.connected) {
                      return Card(
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(18),
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
                                '아직 연결된 커플이 없어요',
                                textAlign: TextAlign.center,
                                style: textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '초대 코드를 공유하거나\n상대방의 코드를 입력해 보세요!',
                                textAlign: TextAlign.center,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 24),
                              FilledButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CoupleInvitationPage(),
                                    ),
                                  );
                                },
                                child: const Text('상대방 초대 코드 입력'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor:
                                  AppColors.partnerScheduleContainer,
                              child: Text(
                                nickname.characters.first,
                                style: textTheme.labelLarge?.copyWith(
                                  color: AppColors.onPartnerSchedule,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$nickname님과 연결됨',
                                    style: textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    couple.connectedAt == null
                                        ? '연결 날짜 정보 없음'
                                        : '${couple.connectedAt!.year}.${couple.connectedAt!.month.toString().padLeft(2, '0')}.${couple.connectedAt!.day.toString().padLeft(2, '0')}',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            const SizedBox(
                              width: 8,
                              height: 8,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: AppColors.sharedSchedule,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),
                Text(
                  '내 초대 코드',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        userInfo.when(
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          data: (user) => Text(
                            user.inviteCode,
                            textAlign: TextAlign.center,
                            style: textTheme.displayMedium?.copyWith(
                              letterSpacing: 4,
                            ),
                          ),
                          error: (error, stackTrace) => const Text(
                            '초대 코드를 불러오지 못했어요',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 14),
                        OutlinedButton(
                          onPressed: userInfo.asData == null
                              ? null
                              : () async {
                                  await Clipboard.setData(
                                    ClipboardData(
                                      text: userInfo.asData!.value.inviteCode,
                                    ),
                                  );

                                  if (!context.mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('초대 코드를 복사했어요'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                          child: const Text('코드 복사'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '코드를 상대방에게 공유하면 커플로 연결할 수 있어요. 연결을 해제하면 서로의 일정이 더 이상 공유되지 않아요.',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textTertiary,
                    height: 1.5,
                  ),
                ),

                coupleInfo.when(
                  loading: () => const SizedBox.shrink(),
                  error: (error, stackTrace) => const SizedBox.shrink(),
                  data: (couple) {
                    if (couple.connected) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          '받은 초대 요청',
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),

                        receivedInvitaions.when(
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (error, stackTrace) =>
                              const Text('받은 초대 요청을 불러오지 못했어요'),
                          data: (invitations) {
                            if (invitations.isEmpty) {
                              return Card(
                                margin: EdgeInsets.zero,
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    children: [
                                      const Icon(
                                        CupertinoIcons.envelope_open,
                                        size: 40,
                                        color: AppColors.textTertiary,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        '아직 받은 초대 요청이 없어요',
                                        style: textTheme.titleMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '상대방이 초대 요청을 보내면\n이곳에서 확인할 수 있어요!',
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: AppColors.textSecondary,
                                          height: 1.5,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            return Column(
                              children: invitations.map((invitation) {
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              radius: 32,
                                              backgroundColor:
                                                  AppColors.primaryContainer,
                                              child: Icon(
                                                CupertinoIcons.person,
                                                size: 32,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            const SizedBox(width: 14),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${invitation.senderNickname}님이',
                                                    style:
                                                        textTheme.titleMedium,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    '커플 연결을 요청했어요.',
                                                    style: textTheme.bodyMedium,
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    '상대방을 확인한 후 수락해 주세요.',
                                                    style: textTheme.bodySmall
                                                        ?.copyWith(
                                                          color: AppColors
                                                              .textTertiary,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: OutlinedButton(
                                                onPressed:
                                                    invitationActionState
                                                        .isLoading
                                                    ? null
                                                    : () async {
                                                        await ref
                                                            .read(
                                                              coupleInvitationActionProvider
                                                                  .notifier,
                                                            )
                                                            .rejectInvitation(
                                                              invitation
                                                                  .invitationId,
                                                            );

                                                        if (!context.mounted) {
                                                          return;
                                                        }

                                                        final result = ref.read(
                                                          coupleInvitationActionProvider,
                                                        );

                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              result.hasError
                                                                  ? '초대 요청을 거절하지 못했어요'
                                                                  : '초대 요청을 거절했어요',
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                child: const Text('거절'),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: FilledButton(
                                                onPressed:
                                                    invitationActionState
                                                        .isLoading
                                                    ? null
                                                    : () async {
                                                        await ref
                                                            .read(
                                                              coupleInvitationActionProvider
                                                                  .notifier,
                                                            )
                                                            .acceptInvitation(
                                                              invitation
                                                                  .invitationId,
                                                            );

                                                        if (!context.mounted) {
                                                          return;
                                                        }

                                                        final result = ref.read(
                                                          coupleInvitationActionProvider,
                                                        );

                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              result.hasError
                                                                  ? '초대 요청을 수락하지 못했어요'
                                                                  : '커플 연결이 완료되었어요!',
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                child: const Text('수락'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),

                coupleInfo.when(
                  loading: () => const SizedBox.shrink(),
                  error: (error, stackTrace) => const SizedBox.shrink(),
                  data: (couple) {
                    if (!couple.connected) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      children: [
                        const SizedBox(height: 20),
                        OutlinedButton(
                          onPressed: disconnectionState.isLoading
                              ? null
                              : () async {
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (dialogContext) => AlertDialog(
                                      title: Text('커플 연결을 해제할까요?'),
                                      content: Text(
                                        '연결을 해제하면 서로의 일정을 더 이상 공유할 수 없어요',
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: AppColors.textSecondary,
                                          height: 1.5,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(
                                            dialogContext,
                                            false,
                                          ),
                                          style: TextButton.styleFrom(
                                            foregroundColor:
                                                AppColors.textSecondary,
                                          ),
                                          child: const Text('취소'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(
                                            dialogContext,
                                            true,
                                          ),
                                          style: TextButton.styleFrom(
                                            foregroundColor:
                                                AppColors.destructive,
                                          ),
                                          child: const Text('연결 해제'),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirmed != true || !mounted) return;

                                  await ref
                                      .read(
                                        coupleDisconnectionNotifier.notifier,
                                      )
                                      .disconnectCouple();

                                  if (!context.mounted) return;

                                  final result = ref.read(
                                    coupleDisconnectionNotifier,
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        result.hasError
                                            ? '커플 연결을 해제하지 못했어요'
                                            : '커플 연결을 해제했어요',
                                      ),
                                    ),
                                  );
                                },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: AppColors.background,
                            foregroundColor: AppColors.destructive,
                            side: const BorderSide(
                              color: AppColors.destructiveOutline,
                            ),
                            minimumSize: const Size.fromHeight(50),
                          ),
                          child: const Text('커플 연결 해제'),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
