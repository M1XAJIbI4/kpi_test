import 'package:kpi_test/domain/model/task.dart';

abstract interface class TasksRepository {
  Future<List<Task>> getTasks();
} 