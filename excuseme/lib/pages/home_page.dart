import 'package:flutter/material.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic absences;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading
          ? null
          : () async {
              setState(() => loading = true);
              try {
                final response = await getAbsences();
                if (!mounted) return;
                setState(() {
                  absences = response;
                });
              } catch (e) {
                if (!mounted) return;
                setState(() {
                  absences = {"error": e.toString()};
                });
              } finally {
                if (mounted) {
                  setState(() => loading = false);
                }
              }
            },
      child: Text(loading ? "Loading..." : "Get Absences"),
    );
  }
}

// :params: username, password, school
// *optional: start, end, studentId, tenantId
Future<Map<String, dynamic>> getAbsences() async {
  final Dio dio = Dio(
    BaseOptions(validateStatus: (status) => status != null && status < 500),
  );

  final cookieJar = CookieJar();
  dio.interceptors.add(CookieManager(cookieJar));

  final login = await dio.post(
    "https://bulme.webuntis.com/WebUntis/j_spring_security_check",
    data: {
      "j_username": "xxx",
      "j_password": "xxx",
      "school": "bulme",
      "token": "",
    },
    options: Options(contentType: Headers.formUrlEncodedContentType),
  );
  // print(login.headers);

  final response = await dio.get(
    "https://bulme.webuntis.com/WebUntis/api/classreg/absences/students",
    queryParameters: {
      "startDate": "20250908",
      "endDate": "20260712",
      "studentId": 000,
      "excuseStatusId": -1,
    },
    options: Options(headers: {"Accept": "application/json"}),
  );
  // print(response.data);

  await dio.get("https://bulme.webuntis.com/WebUntis/j_spring_security_logout");

  return response.data;
}
