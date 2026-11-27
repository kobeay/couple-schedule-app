import 'dart:io';

import 'package:couple_schedule_app/app/theme/app_colors.dart';
import 'package:couple_schedule_app/features/my/data/models/user_nickname_update_request.dart';
import 'package:couple_schedule_app/features/my/presentation/providers/nickname_update_notifier.dart';
import 'package:couple_schedule_app/features/my/presentation/providers/register_profile_image_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditPage extends ConsumerStatefulWidget {
  final String nickname;
  final String email;
  final String? profileImageUrl;

  const ProfileEditPage({
    super.key,
    required this.nickname,
    required this.email,
    required this.profileImageUrl,
  });

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();

  final _imagePicker = ImagePicker();
  XFile? _selectedImage;

  Future<void> _pickImage(ImageSource source) async {
    final image = await _imagePicker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );

    if (image == null || !mounted) return;

    setState(() {
      _selectedImage = image;
    });
  }

  void _showImagePickerBottomSheet() {
    final textTheme = Theme.of(context).textTheme;

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: SizedBox(
                        width: 200,
                        child: Row(
                          children: [
                            const Icon(CupertinoIcons.photo, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '갤러리에서 사진 선택',
                                textAlign: TextAlign.center,
                                style: textTheme.titleMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: SizedBox(
                        width: 200,
                        child: Row(
                          children: [
                            const Icon(Icons.camera_alt, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '카메라로 사진 촬영',
                                textAlign: TextAlign.center,
                                style: textTheme.titleMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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

    final profileImageState = ref.watch(registerProfileImageNotifier);

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
                    GestureDetector(
                      onTap: _showImagePickerBottomSheet,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 70,
                            backgroundImage: _selectedImage != null
                                ? FileImage(File(_selectedImage!.path))
                                : widget.profileImageUrl != null
                                ? NetworkImage(widget.profileImageUrl!)
                                : null,
                            child:
                                _selectedImage == null &&
                                    widget.profileImageUrl == null
                                ? const Icon(Icons.person, size: 70)
                                : null,
                          ),
                          Positioned(
                            right: 4,
                            bottom: 4,
                            child: CircleAvatar(
                              radius: 17,
                              backgroundColor: AppColors.textIcon,
                              child: const Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
            onPressed: nicknameUpdate.isLoading || profileImageState.isLoading
                ? null
                : () async {
                    final nickname = _nicknameController.text.trim();

                    final isNicknameChanged = nickname != widget.nickname;
                    final isImageChanged = _selectedImage != null;

                    if (!isNicknameChanged && !isImageChanged) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('변경된 내용이 없어요')),
                      );

                      return;
                    }

                    if (nickname.length < 2 || nickname.length > 12) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('닉네임은 2~12자로 입력해 주세요')),
                      );

                      return;
                    }

                    if (isNicknameChanged) {
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
                    }

                    if (isImageChanged) {
                      await ref
                          .read(registerProfileImageNotifier.notifier)
                          .registerProfileImage(_selectedImage!.path);

                      if (!context.mounted) return;

                      final result = ref.read(registerProfileImageNotifier);

                      if (result.hasError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('프로필 사진을 변경하지 못했어요')),
                        );

                        return;
                      }
                    }

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('프로필을 수정했어요')));
                  },
            child: nicknameUpdate.isLoading || profileImageState.isLoading
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
