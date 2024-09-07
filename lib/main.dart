import 'package:flutter/material.dart';
import 'package:kpi_test/injection.dart';
import 'package:kpi_test/presentation/application.dart';

void main() async {
  await configureDependencies();
  runApp(const Application());
}



