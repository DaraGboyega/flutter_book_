import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'notes/Notes.dart';
import 'tasks/Tasks.dart';
import 'utils.dart' as utils;

void main() {

  startMeUp() async {
    Directory docsDir =
        await getApplicationDocumentsDirectory();
    utils.docsDir = docsDir;
    runApp(FlutterBook());
  }
  startMeUp();
}

class FlutterBook extends StatelessWidget {
  Widget build(BuildContext inContext) {

    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('FlutterBook'),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.note),
                text: 'Notes'),
                Tab(icon: Icon(Icons.assignment_turned_in),
                text: 'Tasks')
              ]
            ),
          ),
          body: TabBarView(
            children: [
             Notes(), Tasks()
            ],
          ),
        ),
      ),
    );
  }
}
