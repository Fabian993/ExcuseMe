import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // ui
  bool _isObscured = true; // for password
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // response
  String accessToken = "";
  String refreshToken = "";

  final Dio dio = Dio();

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await dio.post(
      'http://localhost:8000/api/token/',
      data: {"username": username, "password": password},
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    if (response.statusCode == 200) {
      return response.data; // refresh token
    } else {
      throw Exception('Failed to log in.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text("Login", style: TextStyle(fontSize: 64, color: Colors.deepOrange)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 80, vertical: 16),
          child: TextFormField(
            controller: usernameController, // stores current value
            autofocus: true,
            decoration: InputDecoration(
              icon: Icon(Icons.person_outline),
              border: OutlineInputBorder(),
              hintText: 'Username',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 80, vertical: 16),
          child: TextFormField(
            controller: passwordController,
            obscureText: _isObscured,
            decoration: InputDecoration(
              icon: Icon(Icons.lock_outline),
              border: OutlineInputBorder(),
              hintText: 'Password',
              suffixIcon: IconButton(
                onPressed: () => setState(() {
                  _isObscured = !_isObscured;
                }),
                padding: EdgeInsetsDirectional.symmetric(horizontal: 20),
                icon: Icon(Icons.remove_red_eye_outlined),
              ),
            ),
          ),
        ),
        FloatingActionButton(
          onPressed: () async {
            final response = await login(
              usernameController.text,
              passwordController.text,
            );
            refreshToken = response['refresh'];
            accessToken = response['access'];
            // print('refreshToken: $refreshToken');
            // print('accessToken: $accessToken');
          },
          child: Text(
            "Login",
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
        ),
      ],
    ); // Column
  }
}
