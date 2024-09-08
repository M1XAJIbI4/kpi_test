import 'package:kpi_test/domain/model/task.dart';

abstract interface class TasksRepository {
  Future<List<Task>> getTasks();

  Future<void> updateTask({
    required String parentId,
    required String taskId,
    required int order,
  });

  void close();

  Stream<Task>? getTaskStreamById(String taskId);
} 