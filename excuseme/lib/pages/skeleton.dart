import 'package:flutter/material.dart';
import 'package:excuseme/models/storage.dart';
import 'package:excuseme/pages/login_page.dart';
import 'package:excuseme/pages/home_page.dart';
import 'package:excuseme/pages/settings_page.dart';
import 'package:excuseme/pages/excuses_page.dart';

class Skeleton extends StatefulWidget {
  const Skeleton({super.key});

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> {
  int _pageIndex = 0;
  final List _pages = [HomePage(), ExcusesPage(), SettingsPage()];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 650;

        if (isMobile) {
          return Scaffold(
            appBar: createAppBar(context),
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
                    Icons.edit_document,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: "Excuses",
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
            appBar: createAppBar(context),
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
                          Icons.edit_document,
                          color: Colors.deepOrange,
                        ),
                        label: Text("Excuses"),
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

AppBar createAppBar(BuildContext context) => AppBar(
  title: Row(
    spacing: 20,
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
  actions: [
    Padding(
      padding: const EdgeInsets.only(right: 50.0),
      child: ElevatedButton(
        onPressed: () async {
          final navigator = Navigator.of(context);
          // reset storage
          final StorageManager sm = StorageManager();
          await sm.storage.deleteAll();
          // reset stack and go to login page
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext context) => LoginPage(),
            ), // Your login widget
            (route) => false, // Clears ALL previous routes
          );
        },
        child: Expanded(
          child: Row(
            spacing: 10,
            children: [Icon(Icons.logout_outlined), Text("Logout")],
          ),
        ),
      ),
    ),
  ],
  centerTitle: true,
  backgroundColor: Color(0x000066FF),
);
