import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:kpi_test/logger.dart';

@LazySingleton()
class RestSource {

  static const _authHeader = {
     'Authorization': 'Bearer 48ab34464a5573519725deb5865cc74c'
  };

  Future<List<Map<String, dynamic>>> getTasks() async {
    final dio = Dio();
    dio.options.headers["Content-Type"] = "multipart/form-data";

    final data = FormData.fromMap({
       'period_start': '2024-09-01',
        'period_end': '2024-09-30',
        'period_key': 'month',
        'requested_mo_id': '478',
        'behaviour_key': 'task, kpi_task',
        'with_result': 'false',
        'response_fields': 'name,indicator_to_mo_id,parent_id,order',
        'auth_user_id': '2',
    });
    
    final response = await dio.post(
      'https://development.kpi-drive.ru/_api/indicators/get_mo_indicators',
      data: data,
      options: Options(headers: _authHeader)
    );

    final dataResp = response.data as Map<String, dynamic>;
    final rows = dataResp['DATA']['rows'] as List<dynamic>;
    final maps = <Map<String, dynamic>>[];
    for (final r in rows) {
      maps.add(r as Map<String, dynamic>);
    }
    return maps;
  }


  Future<void> updateTask({
    required String parentId,
    required String taskId,
    required int order,
  }) async {
    final dio = Dio();
    dio.options.headers["Content-Type"] = "multipart/form-data";

    final data = FormData.fromMap({
      'period_start': '2024-09-01',
      'period_end': '2024-09-30',
      'period_key': 'month',
      'auth_user_id': '2',
      'requested_mo_id': '478',
      'indicator_to_mo_id': taskId,
    })
    ..fields.addAll(
      [
        const MapEntry('field_name', 'parent_id'),
        MapEntry('field_value', parentId),
        const MapEntry('field_name', 'order'),
        MapEntry('field_value', '$order'),
      ],
    );

    final response = await dio.post(
      'https://development.kpi-drive.ru/_api/indicators/save_indicator_instance_field',
      data: data,
      options: Options(headers: _authHeader),
    );
    logger.d('resp - ${response.data} $parentId $order $taskId');
  }
}
