import 'package:flutter/material.dart';
import 'package:flutter_book/notes/NotesDBWorker.dart';
import 'package:flutter_book/notes/NotesModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'TasksDBWorker.dart';
import 'TasksModel.dart' show TasksModel, tasksModel;
import '../utils.dart' as utils;

class TasksEntry extends StatelessWidget {

  final TextEditingController _dueDateEditingController =
  TextEditingController();
  final TextEditingController _descriptionEditingController =
  TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TasksEntry() {
    _dueDateEditingController.addListener(() {
      tasksModel.entityBeingEdited.dueDate =
          _dueDateEditingController.text;
    });

    _descriptionEditingController.addListener(() {
      tasksModel.entityBeingEdited.description =
          _descriptionEditingController.text;
    });
  }

  Widget build(BuildContext inContext) {
    _dueDateEditingController.text =
        tasksModel.entityBeingEdited.dueDate;
    _descriptionEditingController.text =
        tasksModel.entityBeingEdited.description;

    return ScopedModel(
        model: tasksModel,
        child: ScopedModelDescendant<TasksModel>(
            builder: (BuildContext inContext, Widget inChild,
                TasksModel inModel) {
              return Scaffold(
                bottomNavigationBar: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: Row(
                    children: [
                      FlatButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          FocusScope.of(inContext).requestFocus(FocusNode());
                          inModel.setStackIndex(0);
                        },
                      ),
                      Spacer(),
                      FlatButton(
                          child: Text("Save"),
                          onPressed: () {
                            _save(inContext, tasksModel);
                          }
                      )
                    ],
                  ),
                ),
                body: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      ListTile(
                        leading: Icon(Icons.note),
                        title: TextFormField(
                          decoration: InputDecoration(hintText: "Description"),
                          controller: _descriptionEditingController,
                          validator: (String inValue) {
                            if (inValue.length == 0) {
                              return "Please enter a description";
                            }
                            return null;
                          },
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.today),
                        title: Text("Due Date"),
                        subtitle: Text(
                            tasksModel.chosenDate == null ? "" : tasksModel
                                .chosenDate),
                        trailing: IconButton(
                            icon: Icon(Icons.edit),
                            color: Colors.blue,
                            onPressed: () async {
                              String chosenDate = await utils.selectDate(
                                  inContext, tasksModel,
                                  tasksModel.entityBeingEdited.dueDate
                              );
                              if (chosenDate != null) {
                                tasksModel.entityBeingEdited.dueDate =
                                    chosenDate;
                              }
                            }
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
        )
    );
  }

  void _save(BuildContext inContext, TasksModel inModel) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    if (inModel.entityBeingEdited.id == null) {
      await TasksDBWorker.db.create(
        tasksModel.entityBeingEdited
      );
    } else {
      await TasksDBWorker.db.update(
        tasksModel.entityBeingEdited
      );
    }

    tasksModel.loadData("tasks", TasksDBWorker.db);

    inModel.setStackIndex(0);

    Scaffold.of(inContext).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        content: Text("Task Saved"),
      )
    );
  }
}
