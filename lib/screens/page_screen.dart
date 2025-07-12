// page_screen.dart
import 'package:flutter/material.dart';
import 'package:maximize/models/page_model.dart' as page_model;


class PageScreen extends StatefulWidget {
  final page_model.PageModel page; // Change Page to PageModel

  const PageScreen({super.key, required this.page});

  @override
  _PageScreenState createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.page.name),
      ),
      body: ListView.builder(
        itemCount: widget.page.tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.page.tasks[index].title), // Ensure TaskModel has a name property
            subtitle: Text(widget.page.tasks[index].description ?? ''), // Ensure TaskModel has a description property
            trailing: Checkbox(
              value: widget.page.tasks[index].completed, // Ensure TaskModel has a completed property
              onChanged: (value) {
                // Update task completion status
                setState(() {
                  // Assuming you have a method to update the task's completion status
                  widget.page.tasks[index].completed = value ?? false; // Update the task's completion status
                });
              },
            ),
          );
        },
      ),
    );
  }
}