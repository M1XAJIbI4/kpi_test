import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpi_test/domain/bloc/task_list_cubit/task_list_cubit.dart';
import 'package:kpi_test/injection.dart';
import 'package:kpi_test/presentation/home_screen/home_screen.dart';

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KPI Test',
      theme: ApplicationTheme.theme,
      home: BlocProvider<TaskListCubit>(
        create: (ctx) => getIt.get<TaskListCubit>(),
        child: const HomeScreen(),
      ),
    );
  }
}

class ApplicationTheme {
  static final theme = ThemeData(
    // canvasColor: Colors.black,
    cardColor: Colors.black45,
    colorScheme: const ColorScheme.dark(
      background: Colors.black87
    )
  );
}