import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:excuseme/models/storage.dart';
import 'package:dio/dio.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // ui
  bool _isObscured = true; // obscure formfield
  bool _stayAuthenticated = false; // checkbox
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // secure storage
  final StorageManager sm = StorageManager();

  // request
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
      throw Exception('Failed to log in: $response');
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
            controller: _usernameController, // stores current value
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
            controller: _passwordController,
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 80, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              CheckboxMenuButton(
                value: _stayAuthenticated,
                onChanged: (value) => setState(() {
                  _stayAuthenticated = !_stayAuthenticated;
                }),
                child: Text("Remember Me"),
              ),
              FloatingActionButton(
                onPressed: () async {
                  final response = await login(
                    _usernameController.text,
                    _passwordController.text,
                  );
                  if (_stayAuthenticated) {
                    sm.storage.write(
                      key: "username",
                      value: _usernameController.text,
                    );
                    sm.storage.write(
                      key: "password",
                      value: _passwordController.text,
                    );
                  }
                  sm.storage.write(key: "access", value: response["access"]);
                  sm.storage.write(key: "refresh", value: response["refresh"]);
                },
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ); // Column
  }
}
