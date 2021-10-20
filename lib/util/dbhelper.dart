import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/model/todo.dart';

class DbHelper {
  static DbHelper _dbHelper = new DbHelper._internal();

  String tblTodo = 'todo';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colDate = 'date';
  String colPriority = 'priority';


  factory DbHelper() => _dbHelper;
  DbHelper._internal();

  static Database? _db;

  Future<Database?> get db async {
    if(_db == null){
      _db = await initializeDb();
    }

    return _db;
  }

  Future<Database> initializeDb() async{
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "todos.db";
    var dbTodos = await openDatabase(path, version: 1, onCreate: _createDb);

    return dbTodos;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
          "CREATE TABLE $tblTodo($colId INTEGER PRIMARY KEY, $colTitle TEXT, "+
          "$colDescription TEXT, $colPriority INTEGER, $colDate TEXT)");
  }

  Future<int> insertTodo(Todo todo) async {
    Database? db = await this.db;
    var newId = db!.insert(tblTodo, todo.toMap());
    return newId;
  }
  
  Future<int> updateTodo(Todo todo) async {
    Database? db = await this.db;
    var updatedId =db!.update(tblTodo, todo.toMap(), where: "$colId = ?",whereArgs: [todo.id]);
    return updatedId;
  }

  Future<int> deleteTodo(int id) async {
    Database? db = await this.db;
    var deletedId = db!.rawDelete("delete from $tblTodo where $colId = $id");
    return deletedId;
  }
  
  Future<List> getTodos() async {
    Database? db = await this.db;
    var todoList = db!.rawQuery("select * from $tblTodo order by $colPriority ASC");
    return todoList;
  }

  Future<int?> getCount() async {
    Database? db = await this.db;
    var count = Sqflite.firstIntValue(
        await db!.rawQuery("select count(*) from $tblTodo")
    );

    return count;
  }

}
