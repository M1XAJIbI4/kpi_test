import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpi_test/domain/bloc/task_cubit/task_cubit.dart';
import 'package:kpi_test/domain/model/task.dart';
import 'package:kpi_test/injection.dart';
import 'package:kpi_test/presentation/common/scaling_button.dart';

class TaskItem extends StatefulWidget {
  final Task task;

  const TaskItem({
    required this.task,
    super.key,
  });

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  final _taskCubit = getIt.get<TaskCubit>();

  @override
  void initState() {
    super.initState();
    _taskCubit.initialize(widget.task.indicatorToMoId);
  }

  @override
  Widget build(BuildContext context) {
    return ScalingButton(
      onTap: () {},
      lowerBound: 0.95,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).focusColor,
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
                color: Colors.white.withOpacity(0.05),
                spreadRadius: 2,
                blurRadius: 2.0),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Задача №${widget.task.indicatorToMoId}'),
              const SizedBox(height: 22.0),
              Text(
                widget.task.name,
                style: const TextStyle(
                  color: Colors.yellow, 
                  fontSize: 19,
                ),
              ),
              const SizedBox(height: 4.0),
              Align(
                alignment: Alignment.bottomRight,
                child: BlocBuilder<TaskCubit, Task?>(
                  bloc: _taskCubit,
                  builder: (_, state) {
                    final order = state?.order ?? widget.task.order;
                    return AnimatedSwitcher(
                      duration: kThemeAnimationDuration,
                      child: Text(
                        order.toString(),
                        key: ValueKey(order),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
