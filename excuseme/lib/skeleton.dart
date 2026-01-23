import 'package:excuseme/pages/home_page.dart';
import 'package:excuseme/pages/login_page.dart';
import 'package:flutter/material.dart';

class Skeleton extends StatefulWidget {
  const Skeleton({super.key});

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> {
  int _pageIndex = 0;
  final List _pages = [LoginPage(), HomePage()];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 650;

        if (isMobile) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "ExcuseMe",
                style: TextStyle(fontSize: 32, color: Colors.deepOrange),
              ),
              centerTitle: true,
              backgroundColor: .from(
                alpha: 1,
                red: 0,
                green: 102 / 255,
                blue: 1,
              ),
            ),
            body: Row(
              children: [Expanded(child: _pages.elementAt(_pageIndex))],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _pageIndex,
              onTap: (int i) {
                setState(() {
                  _pageIndex = i;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.key_outlined, color: Colors.deepOrange),
                  label: "Login",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined, color: Colors.deepOrange),
                  label: "Home",
                ),
              ],
            ),
          );
        } else {
          // desktop
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "ExcuseMe",
                style: TextStyle(fontSize: 32, color: Colors.deepOrange),
              ),
              centerTitle: true,
              backgroundColor: .from(
                alpha: 1,
                red: 0,
                green: 102 / 255,
                blue: 1,
              ),
            ),
            body: Row(
              children: [
                // main content
                Expanded(child: _pages.elementAt(_pageIndex)),

                // optional
                // const VerticalDivider(width: 1),

                // side bar
                NavigationRail(
                  selectedIndex: _pageIndex,
                  labelType: NavigationRailLabelType.all,
                  onDestinationSelected: (i) => setState(() => _pageIndex = i),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.key_outlined, color: Colors.deepOrange),
                      label: Text("Login"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined, color: Colors.deepOrange),
                      label: Text("Home"),
                    ),
                  ],
                ),
              ],
            ),
            // backgroundColor: Colors.
            // drawer: Drawer(),
          );
        }
      },
    );
  }
}
