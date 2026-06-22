import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:excuseme/components/theme_controller.dart';
import 'package:excuseme/models/storage.dart';
import 'package:excuseme/pages/login_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ThemeController>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 20,
      children: [
        Text("Account", style: TextStyle(fontSize: 28)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.logout_outlined),
              tooltip: "Logout",
              onPressed: () async {
                final navigator = Navigator.of(context);

                // reset storage
                final StorageManager sm = StorageManager();
                await sm.storage.deleteAll();

                // reset stack and go to login page
                navigator.pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (BuildContext context) => LoginPage(),
                  ),
                  (route) => false, // Clears ALL previous routes
                );
              },
            ),
          ],
        ),
        Text("Themes", style: TextStyle(fontSize: 28)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => controller.setTheme(ThemeMode.system),
              icon: Icon(Icons.settings_system_daydream_outlined),
              tooltip: 'System theme',
            ),
            IconButton(
              onPressed: () => controller.setTheme(ThemeMode.light),
              icon: Icon(Icons.light_mode_outlined),
              tooltip: 'Light theme',
            ),
            IconButton(
              onPressed: () => controller.setTheme(ThemeMode.dark),
              icon: Icon(Icons.dark_mode_outlined),
              tooltip: 'Dark theme',
            ),
          ],
        ),
      ],
    );
  }
}
