import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/util/dbhelper.dart';
import 'package:todo_app/model/todo.dart';

class TodoDetail extends StatefulWidget {
  final Todo todo;
  TodoDetail(this.todo);



  @override
  State<StatefulWidget> createState() => TodoDetailState(todo);
}

class TodoDetailState extends State {
  DbHelper helper = DbHelper();

  Todo todo;
  TodoDetailState(this.todo);
  final _priorities = ["High", "Medium", "Low"];
  String _priority = "Low";
  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  final List<String> choices = const <String>["Save Todo & Back","Delete Todo","Back"];

  static const mnuSave = 'Save Todo & Back';
  static const mnuDelete = 'Delete Todo';
  static const mnuBack = 'Back';
  static const HIGH = 'High';

  @override
  Widget build(BuildContext context) {
    titleController.text = todo.title;
    descriptionController.text = todo.description!;

    TextStyle? textStyle = Theme.of(context).textTheme.subtitle1;
    return Scaffold(
        appBar:
            AppBar(
                automaticallyImplyLeading: false,
                actions: [PopupMenuButton<String>(
                    onSelected: select,
                    itemBuilder: (BuildContext context){
                      return choices.map((String choice){
                        return PopupMenuItem(value: choice, child: Text(choice));
                      }).toList();
                    })],
                title: Text(todo.title)
            ),
        body: Padding(
          padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10.0),
          child: ListView(children: [
            Column(children: [
              TextField(
                controller: titleController,
                style: textStyle,
                onChanged: (value) => updateTitle(),
                decoration: InputDecoration(
                    labelText: "Title",
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    style: textStyle,
                    onChanged: (value) => updateDescription(),
                    decoration: InputDecoration(
                        labelText: "Description",
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                  )),
              ListTile(
                  title: DropdownButton<String>(
                items: _priorities.map((value) {
                  return DropdownMenuItem(value: value, child: Text(value));
                }).toList(),
                style: textStyle,
                value: retrievePriority(todo.priority),
                onChanged: (value) => updatePriority(value!),
              ))
            ])
          ]),
        ));
  }

  Future<void> select(String value) async {
    int result;
    switch(value){
      case mnuSave:
        save();
        break;
      case mnuDelete:
        Navigator.pop(context, true);
        if (todo.id == null){
          return;
        }

        result = await helper.deleteTodo(todo.id!);
        if(result !=0){
          AlertDialog alertDialog = AlertDialog(
            title: Text("Todo deleted"),
            content: Text("The todo has been deleted"),
          );

          showDialog(context: context, builder: (_) => alertDialog);
        }
        break;
      case mnuBack:
        Navigator.pop(context, true);
        break;
    }
  }

  void save() {
    todo.date = new DateFormat.yMd().format(DateTime.now());
    if(todo.id != null){
      helper.updateTodo(todo);
    } else {
      helper.insertTodo(todo);
    }
    Navigator.pop(context, true);
  }

  void updatePriority(String priorityValue){

    switch(priorityValue) {
      case "High":
        todo.priority = 1;
        break;
      case "Medium":
        todo.priority = 2;
        break;
      case "Low":
        todo.priority = 3;
        break;

    }
    setState(() {
      _priority = priorityValue;
    });
  }

  String retrievePriority(int value){
    return _priorities[value-1];
  }

  void updateTitle() {
    todo.title = titleController.text;
  }

  void updateDescription(){
    todo.description = descriptionController.text;
  }
}
