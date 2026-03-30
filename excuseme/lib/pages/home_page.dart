import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dart_untis_mobile/dart_untis_mobile.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:excuseme/models/storage.dart';

Future<String> getStudentId(String username, String password) async {
  String? untisServer = dotenv.env['UNTIS_SERVER'];
  String? untisSchool = dotenv.env['UNTIS_SCHOOL'];
  final StorageManager sm = StorageManager();
  String? studentId = await sm.storage.read(key: "studentId");

  if (studentId == null) {
    final session = await UntisSession.init(
      untisServer!,
      untisSchool!,
      username,
      password,
    );
    UntisStudentData userData = await session.getUserData();
    // print("UntisSession response: $userData");
    studentId = userData.id.id.toString();
    await sm.storage.write(key: "studentId", value: studentId);
    // print("studentId: $studentId");
  }

  return studentId;
}

// :params: username, password, school
// *optional: start, end, studentId, tenantId
Future<List<dynamic>> getAbsences() async {
  String? untisServer = dotenv.env['UNTIS_SERVER'];
  final StorageManager sm = StorageManager();
  String? username = await sm.storage.read(key: "username");
  String? password = await sm.storage.read(key: "password");
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
    "https://$untisServer/WebUntis/j_spring_security_check",
    data: {
      "j_username": username!,
      "j_password": password!,
      "school": "bulme",
      "token": "",
    },
    options: Options(contentType: Headers.formUrlEncodedContentType),
  );

  String studentId = await getStudentId(username, password);

  final response = await dio.get(
    "https://$untisServer/WebUntis/api/classreg/absences/students",
    queryParameters: {
      "startDate": "20250908",
      "endDate": "20260712",
      "studentId": int.parse(studentId),
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
