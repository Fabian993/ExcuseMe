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
    data: {"username": username, "password": password},
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

Future<void> _postExcuse(
  BuildContext context,
  int absenceId,
  String title,
  String reason,
) async {
  final StorageManager sm = StorageManager();
  final Dio dio = Dio();
  // print(sm.tokens!.access);
  try {
    String? backendAddress = dotenv.env['BACKEND_SERVER'];
    String protocol = dotenv.env['APP_ENV'] == 'prod' ? 'https' : 'http';
    String? bearer = await sm.storage.read(key: 'access');
    String? username = await sm.storage.read(key: 'username');

    dynamic response = await dio.post(
      '$protocol://$backendAddress/api/excuses/',
      data: {
        "absence_id": absenceId,
        "title": title,
        "content": reason,
        "student": username, // if replaced with ID -> status 500
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearer',
        },
      ),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("POST successful!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("POST failed: ${response.statusCode}")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: SelectableText("$e")));
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StorageManager sm = StorageManager();
  final Dio dio = Dio();

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
            return GestureDetector(
              child: Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  title: Text("Absence ID: ${absence['id']}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Date: ${absence['startDate']}"),
                      Text("Start: ${absence['startTime']}"),
                      Text("End: ${absence['endTime']}"),
                      Text("By: ${absence['createdUser']}"),
                      Text("Reason: ${absence['reason']}"),
                      // SelectableText(absence.toString()),
                    ],
                  ),
                ),
              ),
              onTap: () => _showPopup(context, absence),
            );
          },
        );
      },
    );
  }
}

void _showPopup(BuildContext context, dynamic absence) {
  showDialog(
    context: context,
    builder: (context) {
      final TextEditingController inputTitle = TextEditingController();
      final TextEditingController inputContent = TextEditingController();

      return AlertDialog(
        title: Text("Upload Excuse"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: inputTitle,
              decoration: InputDecoration(labelText: "Title"),
            ),
            TextFormField(
              controller: inputContent,
              decoration: InputDecoration(labelText: "Reason"),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("Send"),
            onPressed: () async {
              await _postExcuse(
                context,
                absence['id'],
                inputTitle.text,
                inputContent.text,
              );
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
