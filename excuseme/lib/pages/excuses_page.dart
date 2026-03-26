import 'package:excuseme/models/storage.dart';
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';

class ExcusesPage extends StatefulWidget {
  const ExcusesPage({super.key});

  @override
  State<ExcusesPage> createState() => _ExcusesPageState();
}

class _ExcusesPageState extends State<ExcusesPage> {
  dynamic excuses = '';
  final StorageManager sm = StorageManager();
  final Dio dio = Dio();

  Future<Map<String, dynamic>> getExcuses() async {
    // print(sm.tokens!.access);
    try {
      String bearer = sm.tokens!.access;

      final response = await dio.get(
        'http://192.168.178.50:8000/api/excuses/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $bearer',
          },
        ),
      );
      // if (response.statusCode == 200Bearer) {
      //   return response.data;
      // }
      return response.data;
    } catch (e) {
      return {'Error': e};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        ElevatedButton(
          onPressed: () async {
            dynamic response = await getExcuses();
            setState(() {
              excuses = response['results'];
            });
          },
          child: Text('Get Excuses'),
        ),
        SelectableText('Fetched Excuses: $excuses'),
      ],
    );
  }
}
