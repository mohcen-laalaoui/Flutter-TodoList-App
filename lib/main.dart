import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoy_flutter/models/task_data.dart';
import 'package:todoy_flutter/screens/tasks_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => TaskData(),
      child: const MaterialApp(
        home: TasksScreen(),
      ),
    );
  }
}
