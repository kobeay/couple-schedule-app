import 'package:couple_schedule_app/app/theme/app_colors.dart';
import 'package:couple_schedule_app/features/couple/data/models/couple_met_date_update_request.dart';
import 'package:couple_schedule_app/features/couple/presentation/providers/couple_met_date_update_notifier.dart';
import 'package:couple_schedule_app/features/schedule/presentation/widgets/picker_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MetDatePage extends ConsumerStatefulWidget {
  final DateTime? metDate;

  const MetDatePage({super.key, required this.metDate});

  @override
  ConsumerState<MetDatePage> createState() => _MetDatePageState();
}

class _MetDatePageState extends ConsumerState<MetDatePage> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    _selectedDate = widget.metDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final metDateState = ref.watch(coupleMetDateUpdateNotifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('우리가 만난 날짜'),
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
          padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('우리의 시작은 언제였나요?', style: textTheme.headlineMedium),
                  const SizedBox(height: 10),
                  Text(
                    '두 사람이 처음 만난 날짜를 선택해 주세요',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              Text('만난 날짜', style: textTheme.bodyMedium),
              const SizedBox(height: 8),
              PickerField(
                label:
                    '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                icon: Icons.calendar_today_outlined,
                onTap: () async {
                  final pickerDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2010),
                    lastDate: DateTime.now(),
                  );

                  if (!mounted) return;

                  if (pickerDate != null) {
                    setState(() {
                      _selectedDate = pickerDate;
                    });
                  }
                },
              ),

              const Spacer(),

              FilledButton(
                onPressed: metDateState.isLoading
                    ? null
                    : () async {
                        final request = CoupleMetDateUpdateRequest(
                          metDate: _selectedDate,
                        );

                        await ref
                            .read(coupleMetDateUpdateNotifier.notifier)
                            .updateMetDate(request);

                        if (!context.mounted) return;

                        final result = ref.read(coupleMetDateUpdateNotifier);

                        if (result.hasError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('날짜를 수정하지 못했어요')),
                          );

                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('만난 날짜를 수정했어요')),
                        );

                        Navigator.pop(context);
                      },
                child: const Text('저장하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
