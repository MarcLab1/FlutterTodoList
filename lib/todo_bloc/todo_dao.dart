import 'package:floor/floor.dart';

import 'todo.dart';

@dao
abstract class TodoDao {
  @Query('SELECT * FROM Todo')
  Future<List<Todo>> getTodos();

  @Query('SELECT * FROM Todo')
  Stream<List<Todo>> getTodosStream();

  @insert
  Future<void> insertTodo(Todo todo);

  @Query('DELETE FROM Todo')
  Future<void> deleteAllTodos();

  @delete
  Future<void> deleteTodo(Todo todo);

  @update
  Future<void> updateTodo(Todo todo);

  @Query('SELECT DISTINCT COUNT(id) FROM Todo')
  Stream<int?> getTodoCountStream();

  @Query('SELECT DISTINCT COUNT(id) FROM Todo')
  Future<int?> getTodoCount();

  @Query('SELECT MAX(id) FROM Todo')
  Future<int?> getMaxTodoId();

  @Query('SELECT * FROM Todo WHERE name LIKE :name')
  Future<List<Todo>> getTodosLike(String name);
}
