import 'package:flutter/material.dart';
import 'package:excuseme/pages/home_page.dart';
import 'package:excuseme/pages/settings_page.dart';
import 'package:excuseme/pages/statistics_page.dart';

class Skeleton extends StatefulWidget {
  const Skeleton({super.key});

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> {
  int _pageIndex = 0;
  final List _pages = [HomePage(), StatisticsPage(), SettingsPage()];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 650;

        if (isMobile) {
          return Scaffold(
            appBar: AppBar(
              title: Row(
                spacing: 10,
                children: [
                  const Image(image: AssetImage("assets/icon.png"), height: 32),
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
            ),
            body: SafeArea(
              child: Expanded(
                child: Center(child: _pages.elementAt(_pageIndex)),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _pageIndex,
              showSelectedLabels: true,
              onTap: (int i) {
                setState(() {
                  _pageIndex = i;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.auto_graph_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: "Statistics",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.settings_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: "Settings",
                ),
              ],
            ),
          );
        } else {
          // desktop
          return Scaffold(
            appBar: AppBar(
              title: Row(
                spacing: 10,
                children: [
                  const Image(image: AssetImage("assets/icon.png"), height: 32),
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
            ),
            body: SafeArea(
              child: Row(
                children: [
                  // main content
                  Expanded(child: Center(child: _pages.elementAt(_pageIndex))),

                  // optional
                  // const VerticalDivider(width: 1),

                  // side bar
                  NavigationRail(
                    selectedIndex: _pageIndex,
                    labelType: NavigationRailLabelType.all,
                    onDestinationSelected: (i) =>
                        setState(() => _pageIndex = i),
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(
                          Icons.home_outlined,
                          color: Colors.deepOrange,
                        ),
                        label: Text("Home"),
                      ),
                      NavigationRailDestination(
                        icon: Icon(
                          Icons.auto_graph_outlined,
                          color: Colors.deepOrange,
                        ),
                        label: Text("Statistics"),
                      ),
                      NavigationRailDestination(
                        icon: Icon(
                          Icons.settings_outlined,
                          color: Colors.deepOrange,
                        ),
                        label: Text("Settings"),
                      ),
                    ],
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
