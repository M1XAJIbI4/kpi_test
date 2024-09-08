import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kpi_test/domain/model/task.dart';
import 'package:kpi_test/domain/repository/tasks_repository.dart';
import 'package:kpi_test/logger.dart';

part 'task_list_state.dart';

@injectable
class TaskListCubit extends Cubit<TaskListState> {
  final TasksRepository _tasksRepository;

  var _allTaskMap = <String, Task>{};

  TaskListCubit(this._tasksRepository) : super(TaskListStateReady.empty()) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final tasks = await _tasksRepository.getTasks();
      final state = _configureState([...tasks]);
      emit(state);
    } catch (e, st) {
      logger.e('ERROR - $e, \n ST $st');
    }
  }

  bool isUpdating = false;

  Future<void> updateTask({
    required String taskId,
    required String parentId,
    required int newOrder,
  }) async {
    final currentState = state as TaskListStateReady;
    try {
      final oldTask = _allTaskMap[taskId];      
      if (oldTask?.parentId != parentId || oldTask?.order != newOrder) {
        emit(TaskListStateLoading());
        await _tasksRepository.updateTask(
          parentId: parentId,
          order: newOrder,
          taskId: taskId
        );
        emit(currentState);
      }

    } catch (e, st) {
      emit(TaskListStateError());
      Future.delayed(const Duration(seconds: 2)).then((_) => _initialize());
      logger.e('ERROR - $e, \n ST $st');
      emit(currentState);
    }
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

    _allTaskMap = {...taskMap};
    return TaskListStateReady(
      allTasksMap: {...taskMap}, 
      configuredTaskMap: {...configuredTaskMap},
    );
  }
}
