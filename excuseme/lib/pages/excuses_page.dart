import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:excuseme/models/storage.dart';

Future<List<dynamic>> getExcuses() async {
  final StorageManager sm = StorageManager();
  final Dio dio = Dio();
  // print(sm.tokens!.access);
  try {
    String? backendAddress = dotenv.env['BACKEND_SERVER'];
    String? bearer = await sm.storage.read(key: 'access');

    final response = await dio.get(
      'https://$backendAddress/api/excuses/',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearer',
        },
      ),
    );
    List<dynamic> excuses = response.data['results'];

    return excuses;
  } catch (e) {
    return [
      {'Error': e},
    ];
  }
}

class ExcusesPage extends StatefulWidget {
  const ExcusesPage({super.key});

  @override
  State<ExcusesPage> createState() => _ExcusesPageState();
}

class _ExcusesPageState extends State<ExcusesPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: getExcuses(),
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
            final excuse = snapshot.data![index];
            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                title: Text("Excuse ID: ${excuse['id']} - ${excuse['title']}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Date: ${excuse['created_at']}"),
                    Text("Content: ${excuse['content']}"),
                    Text(
                      "User: ${excuse['uploaded_by_user'].toString().split(':')[1].split(',')[0]}",
                    ),
                    SelectableText(excuse.toString()),
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
