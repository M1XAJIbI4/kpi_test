import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kpi_test/domain/model/task.dart';
import 'package:kpi_test/domain/repository/tasks_repository.dart';

@injectable
class TaskListCubit extends Cubit<TaskListState> {
  final TasksRepository _tasksRepository;

  TaskListCubit(this._tasksRepository) : super(TaskListState.empty()) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final tasks = await _tasksRepository.getTasks();
      final state = _configureState(tasks);
      emit(state);

    } catch (e, st) {
      debugPrint('ERROR - $e, \n ST $st');
    }
  }

  Map<String, List<Task>> _configureTaskMap(List<Task> tasks) {
    var result = <String, List<Task>>{};

    for (final task in tasks) {
      final parentId = task.parentId;
      if (result.containsKey(parentId)) {
        final currentTasksValue = result[parentId] ?? [];
        result[parentId] = [task, ...currentTasksValue];
      } else {
        result[parentId] = [task];
      }
    }

    return result;
  }

  TaskListState _configureState(List<Task> tasks) {
    final taskMap = <String, Task>{};
    final configuredTaskMap = <String, List<Task>>{};

    for (final task in tasks) {
      final parentId = task.parentId;
      taskMap.addAll({task.indicatorToMoId: task});
      if (configuredTaskMap.containsKey(parentId)) {
        final currentTasksValue = configuredTaskMap[parentId] ?? [];
        configuredTaskMap[parentId] = [task, ...currentTasksValue];
      } else {
        configuredTaskMap[parentId] = [task];
      }
    }

    for (final value in configuredTaskMap.values) {
      value.sort((a, b) => a.order.compareTo(b.order));
    }

    return TaskListState(
        allTasksMap: taskMap, configuredTaskMap: configuredTaskMap);
  }
}

class TaskListState {
  final Map<String, Task> allTasksMap;
  final Map<String, List<Task>> configuredTaskMap;

  TaskListState({
    required this.allTasksMap,
    required this.configuredTaskMap,
  });

  TaskListState.empty(): allTasksMap = {}, configuredTaskMap = {};

  bool get isEmpty => allTasksMap.isEmpty;
}
