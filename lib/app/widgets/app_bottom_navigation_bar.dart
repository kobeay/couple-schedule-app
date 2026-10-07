import 'package:couple_schedule_app/app/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.outline)),
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: AppColors.background,
          // 내가 정한 배경색 위에 마음대로 색조 덧씌우기 X
          surfaceTintColor: Colors.transparent,
          // 하단 네비게이션 바를 평평하게 보이도록 함
          elevation: 0,
          height: 72,
          // 선택된 아이콘 뒤에 둥근 배경 제거
          indicatorColor: Colors.transparent,
          // 하단 아이콘 아래의 글자를 항상 보여라
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          //
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
            (states) => IconThemeData(
              size: 22,
              color: states.contains(WidgetState.selected)
                  ? theme.colorScheme.primary
                  : AppColors.navigationInactive,
            ),
          ),
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
            (states) => textTheme.labelSmall!.copyWith(
              color: states.contains(WidgetState.selected)
                  ? theme.colorScheme.primary
                  : AppColors.navigationInactive,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          destinations: const [
            NavigationDestination(icon: Icon(CupertinoIcons.house), label: '홈'),
            NavigationDestination(
              icon: Icon(CupertinoIcons.calendar),
              label: '일정',
            ),
            NavigationDestination(
              icon: Icon(CupertinoIcons.person),
              label: '마이',
            ),
          ],
        ),
      ),
    );
  }
}
