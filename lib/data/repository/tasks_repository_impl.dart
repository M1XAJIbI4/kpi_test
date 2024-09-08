import 'package:injectable/injectable.dart';
import 'package:kpi_test/data/source/rest_source.dart';
import 'package:kpi_test/domain/model/task.dart';
import 'package:kpi_test/domain/repository/tasks_repository.dart';
import 'package:rxdart/subjects.dart';

@LazySingleton(as: TasksRepository)
class TasksRepositoryImpl implements TasksRepository {
  final RestSource _restSource;

  TasksRepositoryImpl(
    this._restSource,
  );

  final _tasksOrdersSubjectMap = <String, BehaviorSubject<Task>>{};

  @override
  Future<List<Task>> getTasks() async {
    final taskMap = await _restSource.getTasks();
    final result = taskMap.map((map) {
      final task = Task.fromMap(map);
      _checkSubjectInMap(task);
      return task;
    }).toList();
    return result;
  }

  void _checkSubjectInMap(Task task) {
    final id = task.indicatorToMoId;
    if (_tasksOrdersSubjectMap.containsKey(id)) {
      final mapTask = _tasksOrdersSubjectMap[id];
      if (mapTask?.value != task) {
        _tasksOrdersSubjectMap[id]?.add(task);
      }
    } else {
      final subject = BehaviorSubject<Task>();
      _tasksOrdersSubjectMap[id] = subject;
      _tasksOrdersSubjectMap[id]?.add(task);
    }
    
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

  @override
  void close() {
    for (final key in _tasksOrdersSubjectMap.keys) {
      _tasksOrdersSubjectMap[key]?.close();
    }
  }

  @override
  Stream<Task>? getTaskStreamById(String taskId) {
    return _tasksOrdersSubjectMap[taskId]?.stream;
  }
}
