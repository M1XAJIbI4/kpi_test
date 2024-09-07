import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kpi_test/domain/model/task.dart';
import 'package:kpi_test/domain/repository/tasks_repository.dart';

@injectable
class TaskListCubit extends Cubit<List<Task>> {
  final TasksRepository _tasksRepository;

  TaskListCubit(this._tasksRepository): super([]) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final tasks = await _tasksRepository.getTasks();
      _configureTaskMap(tasks);
      emit([...tasks]);
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

}