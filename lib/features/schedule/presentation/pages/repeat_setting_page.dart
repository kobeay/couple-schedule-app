import 'package:couple_schedule_app/app/theme/app_colors.dart';
import 'package:couple_schedule_app/features/schedule/data/models/repeat_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RepeatSettingPage extends ConsumerStatefulWidget {
  const RepeatSettingPage({super.key});

  @override
  ConsumerState<RepeatSettingPage> createState() => _RepeatSettingPageState();
}

class _RepeatSettingPageState extends ConsumerState<RepeatSettingPage> {
  RepeatType _selectedRepeatType = RepeatType.none;
  bool _hasEndDate = false;
  DateTime _selectedDate = DateTime.now();

  Widget _buildSelctionTile({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(
        selected
            ? Icons.radio_button_checked_rounded
            : Icons.radio_button_unchecked_rounded,
        color: selected ? colorScheme.primary : AppColors.textTertiary,
      ),
      title: Text(
        title,
        style: selected ? textTheme.titleMedium : textTheme.bodyLarge,
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('반복'),
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
          child: ListView(
            children: [
              Text('반복 유형', style: textTheme.bodyMedium),
              const SizedBox(height: 8),
              Card(
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    for (final type in RepeatType.values) ...[
                      _buildSelctionTile(
                        title: type.label,
                        selected: _selectedRepeatType == type,
                        onTap: () {
                          setState(() {
                            _selectedRepeatType = type;
                          });
                        },
                      ),
                      if (type != RepeatType.values.last)
                        const Divider(height: 1, indent: 56, endIndent: 10),
                    ],
                  ],
                ),
              ),

              if (_selectedRepeatType != RepeatType.none) ...[
                const SizedBox(height: 25),
                Text('기간', style: textTheme.bodyMedium),
                const SizedBox(height: 8),
                Card(
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _buildSelctionTile(
                        title: '종료일 없음',
                        selected: !_hasEndDate,
                        onTap: () {
                          setState(() {
                            _hasEndDate = false;
                          });
                        },
                      ),
                      const Divider(height: 1, indent: 56, endIndent: 10),
                      _buildSelctionTile(
                        title: _hasEndDate
                            ? '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}'
                            : '종료일 지정',
                        selected: _hasEndDate,
                        onTap: () async {
                          final pickerDate = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(2026),
                            lastDate: DateTime(2100),
                          );

                          if (!mounted) return;

                          if (pickerDate != null) {
                            setState(() {
                              _hasEndDate = true;
                              _selectedDate = pickerDate;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
