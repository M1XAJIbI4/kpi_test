import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kpi_test/domain/model/task.dart';
import 'package:kpi_test/domain/repository/tasks_repository.dart';

@injectable
class TaskCubit extends Cubit<Task?> {
  final TasksRepository _tasksRepository;

  TaskCubit(this._tasksRepository) : super(null);

  StreamSubscription? _taskSubscription;

  Future<void> initialize(String taskId) async {
    print('FOOBAR initialize');
    _taskSubscription = _tasksRepository
        .getTaskStreamById(taskId)
        ?.listen((task) {
          print("FOOBAR on event - ${task.name} - ${task.order} ${task.indicatorToMoId}");
          emit(task);
        });
  }

  @override
  Future<void> close() {
    _taskSubscription?.cancel();
    return super.close();
  }
}
