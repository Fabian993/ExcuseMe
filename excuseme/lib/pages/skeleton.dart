import 'package:flutter/material.dart';
import 'package:excuseme/pages/home_page.dart';
import 'package:excuseme/pages/settings_page.dart';
import 'package:excuseme/pages/excuses_page.dart';
import 'package:excuseme/pages/parent_page.dart';
import 'package:excuseme/pages/teacher_page.dart';
import 'package:excuseme/pages/statistics_page.dart';

class _Tab {
  final Widget page;
  final String label;
  final IconData icon;
  const _Tab(this.page, this.label, this.icon);
}

class Skeleton extends StatefulWidget {
  final String role;
  const Skeleton({super.key, required this.role});

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> {
  int _pageIndex = 0;

  List<_Tab> _tabs() {
    switch (widget.role) {
      case 'parent':
        return [
          const _Tab(ParentPage(), 'Excuses', Icons.edit_document),
          const _Tab(StatisticsPage(), 'Stats', Icons.bar_chart),
          const _Tab(SettingsPage(), 'Settings', Icons.settings_outlined),
        ];
      case 'teacher':
        return [
          const _Tab(TeacherPage(), 'Excuses', Icons.edit_document),
          const _Tab(StatisticsPage(), 'Stats', Icons.bar_chart),
          const _Tab(SettingsPage(), 'Settings', Icons.settings_outlined),
        ];
      default:
        return [
          const _Tab(HomePage(), 'Home', Icons.home_outlined),
          const _Tab(ExcusesPage(), 'Excuses', Icons.edit_document),
          const _Tab(StatisticsPage(), 'Stats', Icons.bar_chart),
          const _Tab(SettingsPage(), 'Settings', Icons.settings_outlined),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = _tabs();
    if (_pageIndex >= tabs.length) _pageIndex = 0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 650;

        if (isMobile) {
          return Scaffold(
            appBar: createAppBar(context),
            body: SafeArea(
              child: Expanded(
                child: Center(child: tabs[_pageIndex].page),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _pageIndex,
              showSelectedLabels: true,
              onTap: (i) => setState(() => _pageIndex = i),
              items: tabs.map((t) => BottomNavigationBarItem(
                icon: Icon(t.icon, color: Theme.of(context).colorScheme.primary),
                label: t.label,
              )).toList(),
            ),
          );
        } else {
          return Scaffold(
            appBar: createAppBar(context),
            body: SafeArea(
              child: Row(
                children: [
                  Expanded(child: Center(child: tabs[_pageIndex].page)),
                  NavigationRail(
                    selectedIndex: _pageIndex,
                    labelType: NavigationRailLabelType.all,
                    onDestinationSelected: (i) => setState(() => _pageIndex = i),
                    destinations: tabs.map((t) => NavigationRailDestination(
                      icon: Icon(t.icon, color: Colors.deepOrange),
                      label: Text(t.label),
                    )).toList(),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

AppBar createAppBar(BuildContext context) => AppBar(
  title: Row(
    spacing: 20,
    children: [
      const Image(image: AssetImage("assets/icon-1024.png"), height: 32),
      Text(
        "ExcuseMe",
        style: TextStyle(
          fontSize: 32,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    ],
  ),
  centerTitle: true,
  backgroundColor: Color(0x000066FF),
);
