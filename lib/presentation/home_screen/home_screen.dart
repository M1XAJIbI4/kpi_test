import 'dart:math';

import 'package:appflowy_board/appflowy_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpi_test/domain/bloc/task_list_cubit/task_list_cubit.dart';
import 'package:kpi_test/domain/model/task.dart';
import 'package:kpi_test/presentation/home_screen/task_item.dart';

part 'empty_tasks_widget.dart';
part 'kanban_board.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late final TaskListCubit _taskListCubit;

  @override
  void initState() {
    super.initState();
    _taskListCubit = context.read<TaskListCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KPI TEST'),
      ),
      body: SafeArea(
        child: BlocBuilder<TaskListCubit, TaskListState>(
          bloc: _taskListCubit,
          builder: (ctx, taskListState) {
            return AnimatedSwitcher(
              duration: kThemeAnimationDuration,
              child: taskListState.isEmpty
                  ? const _EmptyTasksWidget()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                      child: _KanbanBoardWidget(
                        allTasksMap: taskListState.allTasksMap,
                        sortedTasks: taskListState.configuredTaskMap,
                      )
                    ),
            );
          },
        )
      ),
    );
  }
}
