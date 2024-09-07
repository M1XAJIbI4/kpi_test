import 'package:flutter/material.dart';
import 'package:kpi_test/domain/model/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;

  const TaskItem({
    required this.task,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 2, blurRadius: 2.0),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.name),
                const SizedBox(height: 20),
                Text(task.order.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}