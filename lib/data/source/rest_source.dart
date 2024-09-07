import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;

@LazySingleton()
class RestSource {
  Future<List<Map<String, dynamic>>> getTasks() async {
    final response = await http.post(
        Uri.parse(
            'https://development.kpi-drive.ru/_api/indicators/get_mo_indicators'),
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

    var decodedBody = utf8.decode(response.bodyBytes);
    final a = jsonDecode(decodedBody) as Map<String, dynamic>;
    final rows = a['DATA']['rows'] as List<dynamic>;
    final maps = <Map<String, dynamic>>[];
    for (final r in rows) {
      maps.add(r as Map<String, dynamic>);
    }

    return maps;
  }
}
