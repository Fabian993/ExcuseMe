import 'package:excuseme/pages/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
      themeMode: ThemeMode.system,
      home: LoginPage(),
    );
  }
}
