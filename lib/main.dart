import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kpi_test/injection.dart';

void main() async {
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  List<String> _data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _data.length,
                itemBuilder: (_, index) {
                  final item = _data[index];
                  return Text(item);
                },
              ),
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getDataFromRest,
        tooltip: 'GET DATA',
        child: const Icon(Icons.data_saver_off_outlined),
      ),
    );
  }

  Future<void> _getDataFromRest() async {
    try {
      final r = await http.post(
          Uri.parse('https://development.kpi-drive.ru/_api/indicators/get_mo_indicators'),
          body: {
            'period_start': '2024-06-01',
            'period_end': '2024-06-30',
            'period_key': 'month',
            'requested_mo_id': '478',
            'behaviour_key': 'task,kpi_task',
            'with_result': 'false',
            'response_fields': 'name,indicator_to_mo_id,parent_id,order',
            'auth_user_id': '2',
          },
          headers: {
            'Authorization': 'Bearer 48ab34464a5573519725deb5865cc74c',
          });

     

      var decodedBody = utf8.decode(r.bodyBytes);

      final a = jsonDecode(decodedBody) as Map<String, dynamic>;
      print(a);
      final data = a['DATA'] as Map<String, dynamic>;
      print(data);

      final rows = data['rows'] as List<dynamic>;
      final maps = <Map<String, dynamic>>[];
      for (final r in rows) {
        maps.add(r as Map<String, dynamic>);
      }
      print(rows);

      print(rows.runtimeType);
    } catch (err) {
      print('FOOBAR ERROR - $err');
    }
  }
}
