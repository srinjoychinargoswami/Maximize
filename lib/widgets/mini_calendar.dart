import 'package:flutter/material.dart';

class MiniCalendar extends StatefulWidget {
  const MiniCalendar({super.key});

  @override
  _MiniCalendarState createState() => _MiniCalendarState();
}

class _MiniCalendarState extends State<MiniCalendar> {
  final DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth, // Use the available width
          height: constraints.maxHeight, // Use the available height
          child: Column(
            children: [
              Text(
                'Today: ${_focusedDay.month}/${_focusedDay.day}/${_focusedDay.year}',
                style: TextStyle(fontSize: 24),
              ),
              Expanded(
                child: // Your task list widget here, e.g. TaskListScreen(),
                // For demonstration purposes, I'll use a simple ListView
                ListView.builder(
                  itemCount: 10, // Replace with actual task count
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Task ${index + 1}'),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}