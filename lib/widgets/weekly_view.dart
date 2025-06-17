import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maximize/providers/provider.dart';

class WeeklyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('This Week'),
      ),
      body: taskProvider.tasks.isNotEmpty
          ? ListView.builder(
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.tasks[index];

                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description ?? ''),
                  trailing: Checkbox(
                    value: task.completed,
                    onChanged: (value) {
                      taskProvider.updateTask(task.copyWith(completed: value!));
                    },
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}