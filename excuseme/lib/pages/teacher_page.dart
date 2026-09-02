import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:excuseme/models/storage.dart';
import 'package:excuseme/utils/protocol.dart';

class TeacherPage extends StatefulWidget {
  const TeacherPage({super.key});

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  final Dio dio = Dio();
  List<dynamic> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    final sm = StorageManager();
    final bearer = await sm.storage.read(key: 'access');
    final ba = dotenv.env['BACKEND_SERVER'];
    final p = protocol();

    try {
      final r = await dio.get('$p://$ba/api/excuseteacher/',
        options: Options(headers: {'Authorization': 'Bearer $bearer'}));
      setState(() { _items = r.data['results'] ?? []; _loading = false; });
    } catch (_) { setState(() => _loading = false); }
  }

  Future<void> _confirm(int id) async {
    final sm = StorageManager();
    final bearer = await sm.storage.read(key: 'access');
    final ba = dotenv.env['BACKEND_SERVER'];
    final p = protocol();
    await dio.post('$p://$ba/api/excuseteacher/$id/confirm/',
      options: Options(headers: {'Authorization': 'Bearer $bearer'}));
    _fetch();
  }

  Future<void> _reject(int id) async {
    final sm = StorageManager();
    final bearer = await sm.storage.read(key: 'access');
    final ba = dotenv.env['BACKEND_SERVER'];
    final p = protocol();
    await dio.post('$p://$ba/api/excuseteacher/$id/reject/',
      options: Options(headers: {'Authorization': 'Bearer $bearer'}));
    _fetch();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const CircularProgressIndicator();
    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (_, i) {
        final item = _items[i];
        final excuse = item['excuse'] ?? {};
        final status = item['status']?['name'] ?? 'Unknown';
        return Card(margin: const EdgeInsets.all(10), child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${excuse['title']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Student: ${excuse['student']?['user']?['username'] ?? '?'}'),
            Text('Status: $status'),
            if (status == 'Pending') Row(children: [
              ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () => _confirm(item['id']),
                child: const Text('Confirm', style: TextStyle(color: Colors.white))),
              const SizedBox(width: 10),
              ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => _reject(item['id']),
                child: const Text('Reject', style: TextStyle(color: Colors.white))),
            ]),
          ]),
        ));
      },
    );
  }
}
