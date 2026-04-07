import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:dio/dio.dart';
import 'package:excuseme/pages/skeleton.dart';
import 'package:excuseme/models/storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // packages
  final StorageManager sm = StorageManager();
  final Dio dio = Dio();

  // vars (ui)
  bool _isAuthenticated = false; // load main app
  bool _stayAuthenticated = false; // checkbox
  bool _stayAuthenticatedStorage = false;
  bool _isObscured = true; // obscure formfield
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<bool> authenticate(String username, String password) async {
    try {
      await dotenv.load(fileName: ".env");
      String? backendAddress = dotenv.env['BACKEND_SERVER'];

      final response = await dio.post(
        'https://$backendAddress/api/token/',
        data: {"username": username, "password": password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (response.statusCode == 200) {
        // print(response.data);
        await sm.storage.write(key: "username", value: username);
        await sm.storage.write(key: "password", value: password);
        await sm.storage.write(key: "access", value: response.data["access"]);
        await sm.storage.write(key: "refresh", value: response.data["refresh"]);
        return true; // refresh token
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  Future<void> updateTokens() async {
    String? us = await sm.storage.read(key: "username");
    String? pw = await sm.storage.read(key: "password");
    bool hasSavedCredentials = us != null && pw != null;

    // load remember me
    String? stayAuthenticatedRaw = await sm.storage.read(
      key: "stayAuthenticated",
    );
    _stayAuthenticatedStorage = stayAuthenticatedRaw != null
        ? bool.parse(stayAuthenticatedRaw)
        : false;

    if (hasSavedCredentials && !_isAuthenticated) {
      _isAuthenticated = await authenticate(us, pw);

      setState(() {
        _isAuthenticated = _isAuthenticated;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    updateTokens();
    if (_stayAuthenticatedStorage) Skeleton();
    if (_isAuthenticated) {
      return Skeleton();
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.2,
                    vertical: 16,
                  ),
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
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.2,
                    vertical: 0,
                  ),
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
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 20,
                        ),
                        icon: Icon(Icons.remove_red_eye_outlined),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Wrap(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 20,
                    children: [
                      SizedBox(
                        width: 180,
                        child: CheckboxMenuButton(
                          value: _stayAuthenticated,
                          onChanged: (value) => setState(() {
                            _stayAuthenticated = !_stayAuthenticated;
                          }),
                          child: Text("Remember Me"),
                        ),
                      ),
                      ElevatedButton(
                        // backgroundColor: Theme.of(context).colorScheme.tertiary,
                        onPressed: () async {
                          _isAuthenticated = await authenticate(
                            _usernameController.text,
                            _passwordController.text,
                          );

                          // allows to load user credentials in the future
                          if (_stayAuthenticated) {
                            await sm.storage.write(
                              key: "stayAuthenticated",
                              value: "true",
                            );
                          } else {
                            await sm.storage.write(
                              key: "stayAuthenticated",
                              value: "false",
                            );
                          }

                          if (!_isAuthenticated && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Something went wrong. Try again",
                                ),
                                behavior: SnackBarBehavior.floating,
                                showCloseIcon: true,
                              ),
                            );
                          }

                          setState(() {
                            _isAuthenticated = _isAuthenticated;
                          });
                        },
                        child: Text("Login"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ); // Column
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
