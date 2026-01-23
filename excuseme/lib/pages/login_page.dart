import 'package:flutter/material.dart';
import 'package:http/http.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text("Login", style: TextStyle(fontSize: 64, color: Colors.deepOrange)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 64, vertical: 16),
          child: TextFormField(
            autofocus: true,
            decoration: InputDecoration(
              icon: Icon(Icons.person_outline),
              border: OutlineInputBorder(),
              hintText: 'Username',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 64, vertical: 16),
          child: TextFormField(
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
          onPressed: () => {},
          child: Text(
            "Login",
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
        ),
      ],
    ); // Column
  }
}
