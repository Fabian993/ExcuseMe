import 'package:flutter/material.dart';
import 'package:http/http.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
            decoration: const InputDecoration(
              icon: Icon(Icons.key_outlined),
              border: OutlineInputBorder(),
              hintText: 'Password',
            ),
          ),
        ),
        FloatingActionButton(
          onPressed: () => {},
          child: Text(
            "Login",
            style: TextStyle(color: Theme.of(context).colorScheme.outline),
          ),
        ),
      ],
    ); // Column
  }
}
