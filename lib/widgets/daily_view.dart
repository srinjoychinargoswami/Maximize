import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class DailyView extends StatelessWidget {
  // A static list to hold the tasks for the day
  final List<Task> tasks = [
    Task(name: 'Meeting with team at 10 AM'),
    Task(name: 'Lunch with client at 1 PM'),
    Task(name: 'Project deadline at 5 PM'),
  ];

  DailyView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current day of the week
    String dayOfWeek = DateFormat('EEEE').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text('Today - $dayOfWeek'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          Task taskInfo = tasks[index];
          return ListTile(
            title: Text(taskInfo.name),
          );
        },
      ),
    );
  }
}

class Task {
  String name;

  Task({required this.name});
}