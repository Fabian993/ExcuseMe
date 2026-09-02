import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:excuseme/models/storage.dart';
import 'package:excuseme/utils/protocol.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final Dio dio = Dio();
  List<dynamic> _stats = [];
  bool _loading = true;
  String _error = '';

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
      final r = await dio.get('$p://$ba/api/statistics/',
        options: Options(headers: {'Authorization': 'Bearer $bearer'}));
      setState(() { _stats = r.data ?? []; _loading = false; });
    } catch (e) {
      setState(() { _error = '$e'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const CircularProgressIndicator();
    if (_error.isNotEmpty) return SelectableText('Error: $_error');
    if (_stats.isEmpty) return const Center(child: Text('No data yet.\nFetch absences first.'));

    return ListView.builder(
      itemCount: _stats.length,
      itemBuilder: (_, i) {
        final s = _stats[i];
        return _StudentStatCard(data: s);
      },
    );
  }
}

class _StudentStatCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const _StudentStatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final total = (data['total'] ?? 0) as int;
    final excused = (data['excused'] ?? 0) as int;
    final rejected = (data['rejected'] ?? 0) as int;
    final pending = (data['pending'] ?? 0) as int;
    final unexcused = (data['unexcused'] ?? 0) as int;

    final sections = [
      if (excused > 0)
        PieChartSectionData(
          value: excused.toDouble(),
          color: Colors.green,
          title: '$excused',
          radius: 50,
          titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      if (rejected > 0)
        PieChartSectionData(
          value: rejected.toDouble(),
          color: Colors.red,
          title: '$rejected',
          radius: 50,
          titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      if (pending > 0)
        PieChartSectionData(
          value: pending.toDouble(),
          color: Colors.orange,
          title: '$pending',
          radius: 50,
          titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      if (unexcused > 0)
        PieChartSectionData(
          value: unexcused.toDouble(),
          color: Colors.grey,
          title: '$unexcused',
          radius: 50,
          titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        ),
    ];

    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${data['student']} (${data['klasse'] ?? '—'})',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (total > 0)
              SizedBox(
                height: 180,
                child: PieChart(
                  PieChartData(
                    sections: sections,
                    centerSpaceRadius: 40,
                    sectionsSpace: 2,
                  ),
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: Text('No absences recorded')),
              ),
            const SizedBox(height: 8),
            _legendRow(Colors.green, 'Excused', excused),
            _legendRow(Colors.red, 'Rejected', rejected),
            _legendRow(Colors.orange, 'Pending', pending),
            _legendRow(Colors.grey, 'Unexcused', unexcused),
            const Divider(),
            Text('Total: $total', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _legendRow(Color color, String label, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(label),
          const Spacer(),
          Text('$count', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
