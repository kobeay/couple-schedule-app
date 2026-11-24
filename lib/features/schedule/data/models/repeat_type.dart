enum RepeatType { none, daily, weekly, monthly, yearly }

extension RepeatTypeExtension on RepeatType {
  String get label {
    switch (this) {
      case RepeatType.none:
        return '반복 안 함';
      case RepeatType.daily:
        return '매일';
      case RepeatType.weekly:
        return '매주';
      case RepeatType.monthly:
        return '매달';
      case RepeatType.yearly:
        return '매년';
    }
  }
}
