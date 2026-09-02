import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:excuseme/models/storage.dart';
import 'package:excuseme/utils/protocol.dart';

class ParentPage extends StatefulWidget {
  const ParentPage({super.key});

  @override
  State<ParentPage> createState() => _ParentPageState();
}

class _ParentPageState extends State<ParentPage> {
  final Dio dio = Dio();
  List<dynamic> _excuses = [];
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
      final r = await dio.get('$p://$ba/api/excuses/',
        options: Options(headers: {'Authorization': 'Bearer $bearer'}));
      setState(() { _excuses = r.data['results'] ?? []; _loading = false; });
    } catch (_) { setState(() => _loading = false); }
  }

  Future<void> _sign(int id) async {
    final sm = StorageManager();
    final bearer = await sm.storage.read(key: 'access');
    final ba = dotenv.env['BACKEND_SERVER'];
    final p = protocol();
    await dio.patch('$p://$ba/api/excuses/$id/sign/',
      data: {"strategy": "django"},
      options: Options(headers: {'Authorization': 'Bearer $bearer'}));
    _fetch();
  }

  Future<void> _reject(int id) async {
    final sm = StorageManager();
    final bearer = await sm.storage.read(key: 'access');
    final ba = dotenv.env['BACKEND_SERVER'];
    final p = protocol();
    await dio.patch('$p://$ba/api/excuses/$id/reject/',
      options: Options(headers: {'Authorization': 'Bearer $bearer'}));
    _fetch();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const CircularProgressIndicator();
    return ListView.builder(
      itemCount: _excuses.length,
      itemBuilder: (_, i) {
        final e = _excuses[i];
        final status = e['status']?['name'] ?? 'Unknown';
        return Card(margin: const EdgeInsets.all(10), child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${e['title']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Student: ${e['student']?['user']?['username'] ?? '?'}'),
            Text('Status: $status'),
            if (e['parent_signed'] == true)
              const Text('✓ Signed by parent', style: TextStyle(color: Colors.green))
            else if (status == 'Pending') Row(children: [
              ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () => _sign(e['id']),
                child: const Text('Sign', style: TextStyle(color: Colors.white))),
              const SizedBox(width: 10),
              ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => _reject(e['id']),
                child: const Text('Reject', style: TextStyle(color: Colors.white))),
            ]),
          ]),
        ));
      },
    );
  }
}
