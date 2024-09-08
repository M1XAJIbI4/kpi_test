import 'package:injectable/injectable.dart';
import 'package:kpi_test/data/source/rest_source.dart';
import 'package:kpi_test/domain/model/task.dart';
import 'package:kpi_test/domain/repository/tasks_repository.dart';

@LazySingleton(as: TasksRepository)
class TasksRepositoryImpl implements TasksRepository {
  final RestSource _restSource;

  TasksRepositoryImpl(
    this._restSource,
  );

  @override
  Future<List<Task>> getTasks() async {
    final taskMap = await _restSource.getTasks();
    final result = taskMap.map((map) => Task.fromMap(map)).toList();
    return result;
  }

  @override
  Future<void> updateTask({
    required String parentId,
    required String taskId,
    required int order,
  }) async {
    await _restSource.updateTask(
        parentId: parentId, taskId: taskId, order: order);
  }
}
