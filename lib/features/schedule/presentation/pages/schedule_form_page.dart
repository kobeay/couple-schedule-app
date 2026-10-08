import 'package:couple_schedule_app/app/theme/app_colors.dart';
import 'package:couple_schedule_app/features/schedule/presentation/widgets/picker_field.dart';
import 'package:couple_schedule_app/features/schedule/presentation/widgets/schedule_type_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScheduleFormPage extends ConsumerStatefulWidget {
  final String initialTitle;
  final DateTime? initialDate;
  final bool isEditing;

  const ScheduleFormPage({
    super.key,
    this.initialTitle = '',
    this.initialDate,
    this.isEditing = false,
  });

  @override
  ConsumerState<ScheduleFormPage> createState() => _ScheduleFormPageState();
}

class _ScheduleFormPageState extends ConsumerState<ScheduleFormPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.isEditing ? '일정 수정' : '일정 추가'),
        leading: IconButton(
          tooltip: '닫기',
          onPressed: () => Navigator.maybePop(context),
          icon: Icon(Icons.close_rounded),
          color: AppColors.textIcon,
        ),
        actions: [
          TextButton(onPressed: () {}, child: const Text('저장')),
          const SizedBox(width: 5),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('일정 제목', style: textTheme.bodyMedium),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: widget.initialTitle,
                  style: textTheme.bodyLarge,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(hintText: '예: 영화 보기'),
                ),

                const SizedBox(height: 25),

                Text('날짜', style: textTheme.bodyMedium),
                const SizedBox(height: 8),
                PickerField(
                  label: '2026-09-05',
                  icon: Icons.calendar_today_outlined,
                  onTap: () {},
                ),

                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('시간', style: textTheme.bodyMedium),
                    FilterChip(
                      label: const Text('시간 미정'),
                      selected: false,
                      onSelected: (value) => {},
                      backgroundColor: AppColors.surfaceMuted,
                      selectedColor: colorScheme.primaryContainer,
                      checkmarkColor: colorScheme.onPrimaryContainer,
                      labelStyle: textTheme.labelMedium?.copyWith(
                        // 시간 미정 선택되면 삼항 연사자 -> colorScheme.onPrimaryContainer로 하기
                        color: AppColors.textSecondary,
                      ),
                      side: BorderSide(
                        // 시간 미정 선택되면 삼항 연사자 -> AppColors.primaryContainerOutliner로 하기
                        color: Colors.transparent,
                      ),
                      shape: const StadiumBorder(),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('시작 시간', style: textTheme.bodyMedium),
                          const SizedBox(height: 8),
                          PickerField(
                            label: '오후 02:00',
                            icon: Icons.access_time_rounded,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('종료 시간', style: textTheme.bodyMedium),
                          const SizedBox(height: 8),
                          PickerField(
                            label: '오후 03:00',
                            icon: Icons.access_time_rounded,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                Text('메모 (선택)', style: textTheme.bodyMedium),
                const SizedBox(height: 8),
                TextFormField(
                  style: textTheme.bodyLarge,
                  minLines: 3,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(hintText: '메모를 남겨보세요!'),
                ),

                const SizedBox(height: 25),

                Text('일정 종류', style: textTheme.bodyMedium),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ScheduleTypeButton(
                      label: '개인',
                      isSelected: true,
                      isShared: false,
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                    ScheduleTypeButton(
                      label: '우리',
                      isSelected: false,
                      isShared: false,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
