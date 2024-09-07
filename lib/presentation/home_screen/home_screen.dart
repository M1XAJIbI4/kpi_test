import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpi_test/domain/bloc/task_list_cubit/task_list_cubit.dart';
import 'package:kpi_test/domain/model/task.dart';

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
      body: SafeArea(
        child: BlocBuilder<TaskListCubit, List<Task>>(
          bloc: _taskListCubit,
          builder: (ctx, tasks) {
            return AnimatedSwitcher(
              duration: kThemeAnimationDuration,
              child: tasks.isEmpty 
                  ? const _EmptyTasksWidget()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                      child: ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (_, index) {
                          final taskItem = tasks[index];
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.25),
                                borderRadius: const BorderRadius.all(Radius.circular(10))
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(taskItem.name),
                                  Text(taskItem.parentId.toString()),
                                  Text(taskItem.indicatorToMoId),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            );
          },
        )
      ),
    );
  }
}

class _EmptyTasksWidget extends StatelessWidget {
  const _EmptyTasksWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No tasks'),
    );
  }
}