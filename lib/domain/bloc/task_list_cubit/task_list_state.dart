part of 'task_list_cubit.dart';

sealed class TaskListState {}

class TaskListStateReady extends TaskListState {
  final Map<String, Task> allTasksMap;
  final Map<String, List<Task>> configuredTaskMap;

  TaskListStateReady({
    required this.allTasksMap,
    required this.configuredTaskMap,
  });

  TaskListStateReady.empty()
      : allTasksMap = {},
        configuredTaskMap = {};
}

class TaskListStateLoading extends TaskListState {}

class TaskListStateError extends TaskListState {}
 