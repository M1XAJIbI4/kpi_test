import 'dart:math';

import 'package:appflowy_board/appflowy_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpi_test/domain/bloc/task_list_cubit/task_list_cubit.dart';
import 'package:kpi_test/domain/model/task.dart';
import 'package:kpi_test/logger.dart';
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
        backgroundColor: Colors.green,
        title: SizedBox(
          width: 200,
          child: Row(
            children: [
              const Text('KPI TEST'),
              const SizedBox(width: 4),
              BlocBuilder<TaskListCubit, TaskListState>(
                bloc: _taskListCubit,
                builder: (_, state) {
                  final isLoading = state is TaskListStateLoading;
                  return AnimatedSwitcher(
                    duration: kThemeAnimationDuration,
                    child: isLoading 
                        ? SizedBox.square(
                            dimension: 16,
                            child: CircularProgressIndicator(
                              color: Theme.of(context).cardColor,
                            ),
                          )
                        : const SizedBox(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: BlocBuilder<TaskListCubit, TaskListState>(
              bloc: _taskListCubit,
              buildWhen: (_, cur) => cur is! TaskListStateLoading,
              builder: (ctx, taskListState) {
                final (allTasksMap, sortedTasksMap) = switch (taskListState) {
                  TaskListStateLoading _ => (<String, Task>{}, <String, List<Task>>{}),
                  TaskListStateReady ready => (ready.allTasksMap, ready.configuredTaskMap),
                };
                return AnimatedSwitcher(
                  duration: kThemeAnimationDuration,
                  child: allTasksMap.isEmpty
                      ? const _EmptyTasksWidget()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                          child: _KanbanBoardWidget(
                            allTasksMap: allTasksMap,
                            sortedTasks: sortedTasksMap,
                          )
                        ),
                );
              },
            )
          ),

          // block screen when updating of task status
          BlocBuilder<TaskListCubit, TaskListState>(
            bloc: _taskListCubit,
            builder: (_, state) {
              final isLoading = state is TaskListStateLoading;
              return AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: isLoading 
                    ? Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.transparent,
                      )
                    : const SizedBox(),
              );
            }
          ),
        ],
      ),
    );
  }
}
