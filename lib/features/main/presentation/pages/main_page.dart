import 'package:couple_schedule_app/app/widgets/app_bottom_navigation_bar.dart';
import 'package:couple_schedule_app/features/home/presentation/pages/home_page.dart';
import 'package:couple_schedule_app/features/schedule/presentation/pages/schedule_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final _pages = const [HomePage(), SchedulePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: AppBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
