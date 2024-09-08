import 'package:flutter/material.dart';
import 'package:kpi_test/domain/model/task.dart';
import 'package:kpi_test/presentation/common/scaling_button.dart';

class TaskItem extends StatelessWidget {
  final Task task;

  const TaskItem({
    required this.task,
    super.key,
  });

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
            BoxShadow(color: Colors.white.withOpacity(0.1), spreadRadius: 2, blurRadius: 2.0),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.indicatorToMoId),
              Text(task.name, style: const TextStyle(color: Colors.yellow),),
              const SizedBox(height: 20),
              Text(task.order.toString()),
            ],
          ),
        ),
      ),
    );
  }
}