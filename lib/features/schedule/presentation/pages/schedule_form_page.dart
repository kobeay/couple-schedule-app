import 'package:couple_schedule_app/app/theme/app_colors.dart';
import 'package:couple_schedule_app/features/couple/presentation/providers/couple_provider.dart';
import 'package:couple_schedule_app/features/schedule/data/models/schedule_create_request.dart';
import 'package:couple_schedule_app/features/schedule/data/models/schedule_type.dart';
import 'package:couple_schedule_app/features/schedule/data/models/schedule_update_request.dart';
import 'package:couple_schedule_app/features/schedule/presentation/providers/schedule_create_notifier.dart';
import 'package:couple_schedule_app/features/schedule/presentation/providers/schedule_update_notifier.dart';
import 'package:couple_schedule_app/features/schedule/presentation/widgets/picker_field.dart';
import 'package:couple_schedule_app/features/schedule/presentation/widgets/schedule_type_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScheduleFormPage extends ConsumerStatefulWidget {
  final bool isEditing;

  final int? scheduleId;

  const ScheduleFormPage({super.key, this.isEditing = false, this.scheduleId});

  @override
  ConsumerState<ScheduleFormPage> createState() => _ScheduleFormPageState();
}

class _ScheduleFormPageState extends ConsumerState<ScheduleFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _memoController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  bool _isTimeUndecided = false;

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  ScheduleType _selectedType = ScheduleType.personal;

  @override
  void dispose() {
    _titleController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  String? _formatTime(TimeOfDay? time) {
    if (time == null) return null;

    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute:00';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final createState = ref.watch(scheduleCreateNotifier);

    final couple = ref.watch(coupleProvider);

    final isConnectedCouple = couple.value?.connected == true;

    final updateState = ref.watch(scheduleUpdateNotifier);

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
          TextButton(
            onPressed: createState.isLoading || updateState.isLoading
                ? null
                : () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    if (_startTime != null && _endTime != null) {
                      final startMinutes =
                          _startTime!.hour * 60 + _startTime!.minute;
                      final endMinutes = _endTime!.hour * 60 + _endTime!.minute;

                      if (startMinutes >= endMinutes) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('종료 시간은 시작 시간보다 늦어야 해요'),
                          ),
                        );
                        return;
                      }
                    }

                    final createRequest = ScheduleCreateRequest(
                      title: _titleController.text.trim(),
                      date: _selectedDate,
                      startTime: _formatTime(_startTime),
                      endTime: _formatTime(_endTime),
                      memo: _memoController.text.trim(),
                      type: isConnectedCouple
                          ? _selectedType
                          : ScheduleType.personal,
                    );

                    final updateRequest = ScheduleUpdateRequest(
                      title: _titleController.text.trim(),
                      date: _selectedDate,
                      startTime: _formatTime(_startTime),
                      endTime: _formatTime(_endTime),
                      memo: _memoController.text.trim(),
                      type: isConnectedCouple
                          ? _selectedType
                          : ScheduleType.personal,
                    );

                    if (widget.isEditing) {
                      await ref
                          .read(scheduleUpdateNotifier.notifier)
                          .updateSchedule(updateRequest, widget.scheduleId!);
                    } else {
                      await ref
                          .read(scheduleCreateNotifier.notifier)
                          .createSchedule(createRequest);
                    }

                    if (!context.mounted) return;

                    final result = widget.isEditing
                        ? ref.read(scheduleUpdateNotifier)
                        : ref.read(scheduleCreateNotifier);

                    if (result.hasError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            widget.isEditing
                                ? '일정을 수정하지 못했어요'
                                : '알정울 추가하지 못했어요',
                          ),
                        ),
                      );

                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          widget.isEditing ? '일정을 수정했어요' : '일정을 추가했어요',
                        ),
                      ),
                    );

                    Navigator.pop(context, true);
                  },
            child: const Text('저장'),
          ),
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('일정 제목', style: textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  TextFormField(
                    style: textTheme.bodyLarge,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(hintText: '예: 영화 보기'),
                    controller: _titleController,
                    maxLength: 30,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '일정 제목을 입력해 주세요';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 25),

                  Text('날짜', style: textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  PickerField(
                    label:
                        '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                    icon: Icons.calendar_today_outlined,
                    onTap: () async {
                      final pickerDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );

                      if (!mounted) return;

                      if (pickerDate != null) {
                        setState(() {
                          _selectedDate = pickerDate;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('시간', style: textTheme.bodyMedium),
                      FilterChip(
                        label: const Text('시간 미정'),
                        selected: _isTimeUndecided,
                        onSelected: (value) {
                          setState(() {
                            _isTimeUndecided = value;

                            if (value) {
                              _startTime = null;
                              _endTime = null;
                            }
                          });
                        },
                        backgroundColor: AppColors.surfaceMuted,
                        selectedColor: colorScheme.primaryContainer,
                        checkmarkColor: colorScheme.onPrimaryContainer,
                        labelStyle: textTheme.labelMedium?.copyWith(
                          color: _isTimeUndecided
                              ? colorScheme.onPrimaryContainer
                              : AppColors.textSecondary,
                        ),
                        side: BorderSide(
                          color: _isTimeUndecided
                              ? AppColors.primaryContainerOutline
                              : Colors.transparent,
                        ),
                        shape: const StadiumBorder(),
                      ),
                    ],
                  ),

                  if (!_isTimeUndecided) ...[
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
                                label:
                                    _startTime?.format(context) ?? '시작 시간 선택',
                                icon: Icons.access_time_rounded,
                                isPlaceholder: _startTime == null,
                                onTap: () async {
                                  final pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: _startTime ?? TimeOfDay.now(),
                                  );

                                  if (!context.mounted) return;

                                  if (pickedTime != null) {
                                    setState(() {
                                      _startTime = pickedTime;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('종료 시간', style: textTheme.bodyMedium),

                                  if (_endTime != null)
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _endTime = null;
                                        });
                                      },
                                      child: Text(
                                        '선택 안 함',
                                        style: textTheme.bodySmall?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              PickerField(
                                label: _endTime?.format(context) ?? '종료 시간 선택',
                                icon: Icons.access_time_rounded,
                                isPlaceholder: _endTime == null,
                                onTap: () async {
                                  if (_startTime == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('시작 시간을 먼저 선택해 주세요'),
                                      ),
                                    );
                                    return;
                                  }

                                  final pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: _endTime ?? TimeOfDay.now(),
                                  );

                                  if (!mounted) return;

                                  if (pickedTime != null) {
                                    setState(() {
                                      _endTime = pickedTime;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 25),

                  Text('메모 (선택)', style: textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  TextFormField(
                    style: textTheme.bodyLarge,
                    minLines: 3,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(hintText: '메모를 남겨보세요!'),
                    controller: _memoController,
                    maxLength: 300,
                  ),

                  const SizedBox(height: 25),

                  if (isConnectedCouple) ...[
                    Text('일정 종류', style: textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ScheduleTypeButton(
                          label: '개인',
                          isSelected: _selectedType == ScheduleType.personal,
                          isShared: false,
                          onPressed: () {
                            setState(() {
                              _selectedType = ScheduleType.personal;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        ScheduleTypeButton(
                          label: '우리',
                          isSelected: _selectedType == ScheduleType.couple,
                          isShared: true,
                          onPressed: () {
                            setState(() {
                              _selectedType = ScheduleType.couple;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
