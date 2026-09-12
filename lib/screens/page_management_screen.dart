import 'package:flutter/material.dart';
import 'package:kinetic/models/page_model.dart' as page_model;

class PageManagementScreen extends StatefulWidget {
  const PageManagementScreen({super.key});

  @override
  _PageManagementScreenState createState() => _PageManagementScreenState();
}

class _PageManagementScreenState extends State<PageManagementScreen> {
  final List<page_model.PageModel> _pages = []; // Change Page to PageModel

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Management'),
      ),
      body: ListView.builder(
        itemCount: _pages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_pages[index].name),
            subtitle: Text(_pages[index].description),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Edit page details
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "page_mangement_fab",
        onPressed: () {
          setState(() {
            _pages.add(page_model.PageModel( // Change Page to PageModel
              id: _pages.length + 1,
              name: 'New Page',
              description: 'This is a new page',
              tasks: [], // Assuming tasks is a List<TaskModel>
            ));
          });
        },
        tooltip: 'Add new page',
        child: Icon(Icons.add),
      ),
    );
  }
}