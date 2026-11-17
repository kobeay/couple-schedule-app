import 'package:couple_schedule_app/app/theme/app_colors.dart';
import 'package:couple_schedule_app/features/my/data/models/user_nickname_update_request.dart';
import 'package:couple_schedule_app/features/my/presentation/providers/nickname_update_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileEditPage extends ConsumerStatefulWidget {
  final String nickname;
  final String email;

  const ProfileEditPage({
    super.key,
    required this.nickname,
    required this.email,
  });

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _nicknameController.text = widget.nickname;
    _emailController.text = widget.email;
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final nicknameUpdate = ref.watch(nicknameUpdateNotifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('내 프로필 수정'),
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
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      child: Icon(Icons.person, size: 40),
                    ),
                    const SizedBox(height: 5),
                    const Text('프로필 사진 변경은 추후 지원 예정'),
                  ],
                ),

                const SizedBox(height: 25),

                Text('닉네임', style: textTheme.bodyMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nicknameController,
                  maxLength: 12,
                  decoration: InputDecoration(counterText: ''),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text('2~12자 이내로 입력해 주세요', style: textTheme.bodySmall),
                ),

                const SizedBox(height: 25),

                Text('이메일', style: textTheme.bodyMedium),
                const SizedBox(height: 8),
                IgnorePointer(
                  child: TextField(
                    controller: _emailController,
                    readOnly: true,
                    style: const TextStyle(color: AppColors.textTertiary),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text('이메일은 변경할 수 없어요', style: textTheme.bodySmall),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: FilledButton(
            onPressed: nicknameUpdate.isLoading
                ? null
                : () async {
                    final nickname = _nicknameController.text.trim();

                    if (nickname == widget.nickname) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('기존 닉네임과 동일해요')),
                      );

                      return;
                    }

                    if (nickname.length < 2 || nickname.length > 12) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('닉네임은 2~12자로 입력해 주세요')),
                      );

                      return;
                    }

                    final request = UserNicknameUpdateRequest(
                      nickname: nickname,
                    );

                    await ref
                        .read(nicknameUpdateNotifier.notifier)
                        .updateNickname(request);

                    if (!context.mounted) return;

                    final result = ref.read(nicknameUpdateNotifier);

                    if (result.hasError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('닉네임을 수정하지 못했어요')),
                      );

                      return;
                    }
                  },
            child: nicknameUpdate.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('저장하기'),
          ),
        ),
      ),
    );
  }
}
