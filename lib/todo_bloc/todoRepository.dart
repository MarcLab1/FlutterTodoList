import 'package:my_app/todo_bloc/database.dart';

import 'todo.dart';

class TodoRepository {
  TodoRepository() {
    deleteAllTodos();
  }
  final databaseProvider = DatabaseService();

  Future<void> deleteAllTodos() async {
    final db = await databaseProvider.database;
    db.todoDao.deleteAllTodos();
  }

  Future<List<Todo>> getTodos() async {
    final db = await databaseProvider.database;
    return db.todoDao.getTodos();
  }

  Stream<List<Todo>> getTodosStream() async* {
    final db = await databaseProvider.database;
    yield* db.todoDao.getTodosStream();
  }

  Future<void> insertTodo(Todo todo) async {
    final db = await databaseProvider.database;
    db.todoDao.insertTodo(todo);
  }

  Future<void> updateTodo(Todo todo) async {
    final db = await databaseProvider.database;
    db.todoDao.updateTodo(todo);
  }

  Future<void> deleteTodo(Todo todo) async {
    final db = await databaseProvider.database;
    db.todoDao.deleteTodo(todo);
  }

  Future<int?> gettodoCount() async {
    final db = await databaseProvider.database;
    return db.todoDao.getTodoCount();
  }

  Stream<int?> gettodoCountStream() async* {
    final db = await databaseProvider.database;
    yield* db.todoDao.getTodoCountStream();
  }

  Future<int?> getMaxTodoId() async {
    final db = await databaseProvider.database;
    return db.todoDao.getMaxTodoId();
  }

  Future<List<Todo>> getTodosLike(String name) async {
    final db = await databaseProvider.database;
    return db.todoDao.getTodosLike(name);
  }
}

class DatabaseService {
  DatabaseService._() {
    initDatabase();
  }
  static DatabaseService? _instance;

  factory DatabaseService() {
    if (_instance == null) {
      _instance = DatabaseService._();
    }
    return _instance!;
  }

  static AppDatabase2? _database = null;
  Future<AppDatabase2> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<AppDatabase2> initDatabase() async {
    return await $FloorAppDatabase2.databaseBuilder('my_db4.db').build();
  }
}
