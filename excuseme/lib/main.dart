import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:excuseme/pages/login_page.dart';
import 'package:excuseme/components/theme_controller.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => ThemeController(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ThemeController>();

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return MaterialApp(
          title: 'ExcuseMe',
          debugShowCheckedModeBanner: false,

          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Color(0x000066FF),
              primary: Colors.deepOrange,
              secondary: Color(0x001a0201),
              brightness: Brightness.light,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Color(0x000066FF),
              primary: Colors.deepOrange,
              secondary: Color(0x001a0201),
              brightness: Brightness.dark,
            ),
          ),
          themeMode: controller.themeMode,
          home: LoginPage(),
        );
      },
    );
  }
}
