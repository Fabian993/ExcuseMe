import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:excuseme/models/storage.dart';

Future<List<dynamic>> getAbsences() async {
  String? backendAddress = dotenv.env['BACKEND_SERVER'];
  String protocol = dotenv.env['APP_ENV'] == 'prod' ? 'https' : 'http';

  final StorageManager sm = StorageManager();
  String? username = await sm.storage.read(key: "username");
  String? password = await sm.storage.read(key: "password");
  String? accessToken = await sm.storage.read(key: "access");

  final Dio dio = Dio();

  final response = await dio.post(
    '$protocol://$backendAddress/api/webuntis/absences/',
    data: {
      "username": username,
      "password": password,
    },
    options: Options(
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    ),
  );

  List<dynamic> absences = response.data['absences'];
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
