import 'package:flutter/material.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

// :params: username, password, school
// *optional: start, end, studentId, tenantId
Future<List<dynamic>> getAbsences() async {
  final Dio dio = Dio(
    BaseOptions(
      followRedirects: true,
      validateStatus: (status) => status != null && status < 500,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  final cookieJar = CookieJar();
  dio.interceptors.add(CookieManager(cookieJar));

  await dio.post(
    "https://bulme.webuntis.com/WebUntis/j_spring_security_check",
    data: {
      "j_username": "xxx",
      "j_password": "xxx",
      "school": "bulme",
      "token": "",
    },
    options: Options(contentType: Headers.formUrlEncodedContentType),
  );

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
  List<dynamic> absences = response.data['data']['absences'];

  // print(absences);

  // await dio.get("https://bulme.webuntis.com/WebUntis/j_spring_security_logout");
  // returns "Server error - the server failed to fulfil an apparently valid request"

  return absences;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: getAbsences(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return SelectableText("Error: ${snapshot.error}");
        }

        if (!snapshot.hasData) {
          return const Text("No data.\nNo, that's a good thing.");
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final absence = snapshot.data![index];
            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                title: Text(
                  "Absence ID: ${absence['id']} - ${absence['studentName']}",
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Date: ${absence['startDate']}"),
                    Text("Reason: ${absence['reason']}"),
                    SelectableText(absence.toString()),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
