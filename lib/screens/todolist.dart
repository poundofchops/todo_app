import 'package:flutter/material.dart';
import 'package:todo_app/screens/tododetail.dart';
import 'package:todo_app/util/dbhelper.dart';
import 'package:todo_app/model/todo.dart';

class TodoList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => TodoListState();
}

class TodoListState extends State{
  DbHelper helper = DbHelper();
  bool todosInitialised = false;
  List<Todo>? todos;
  int todosCount = 0;

  @override
  Widget build(BuildContext context) {
    if(!todosInitialised){
      todos = <Todo>[];
      getData();
    }

    return new Scaffold(
      body: todoListItems(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigateToDetail(Todo('', '', 3, ''));
          },
          tooltip: "Add new todo",
          child: new Icon(Icons.add),
      ),
    );
  }
  
  

  void getData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final todosFuture = helper.getTodos();
      todosFuture.then((todosDbResult){
        List<Todo> todosList = <Todo>[];
        todosCount = todosDbResult.length;
        
        for(int i=0;i< todosCount; i++){
          todosList.add(Todo.fromObject(todosDbResult[i]));
          debugPrint(todosList[i].title);
        }
        setState(() {
          todosInitialised = true;
          todos = todosList;
          todosCount = todosCount;
        });
        debugPrint("Items "+todosCount.toString());
      });
    });
  }

  ListView todoListItems() {
     return ListView.builder(
       itemCount: todosCount,
       itemBuilder: (BuildContext context, int position){
         return Card(
           color: Colors.white,
           elevation: 2.0,
           child: ListTile(
             leading: CircleAvatar(
               backgroundColor: getPriorityColor(this.todos![position].priority),
               child: Text(this.todos![position].priority.toString())
             ),
           title: Text(this.todos![position].title),
             subtitle: Text(this.todos![position].date),
             onTap: (){
               debugPrint("Tapped on "+this.todos![position].id.toString());
               navigateToDetail(this.todos![position]);
             },
           ),
         );
       },
     );
  }

  Color getPriorityColor(int priority){
    switch(priority){
      case 1: {
        return Colors.red;
      }
      case 2: {
        return Colors.orange;
      }
      case 3: {
        return Colors.green;
      }
      default:
        return Colors.green;
    }
  }

  void navigateToDetail(Todo todo) async {
    bool result = await Navigator.push( context,
        MaterialPageRoute(builder: (context) => TodoDetail(todo))
    );
    if(result){
      getData();
    }
  }
}