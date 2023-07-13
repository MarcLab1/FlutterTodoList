import 'package:flutter/material.dart';

import '../todo.dart';

@immutable
abstract class HomeEvent {
  const HomeEvent();
}

class InitialEvent extends HomeEvent {}

class StreamUpdatedEvent extends HomeEvent {
  final List<Todo> todos;
  StreamUpdatedEvent({required this.todos});
}

class AddTodoEvent extends HomeEvent {
  final Todo todo;
  AddTodoEvent(this.todo);
}

class UpdateTodoEvent extends HomeEvent {
  final Todo todo;
  UpdateTodoEvent({required this.todo});
}

class DeleteTodoEvent extends HomeEvent {
  final Todo todo;
  DeleteTodoEvent({required this.todo});
}

class DeleteAllTodosEvent extends HomeEvent {}

class NavigateToDetailScreenEvent extends HomeEvent {
  final Todo todo;
  NavigateToDetailScreenEvent({required this.todo});
}

class RemoveNavEvent extends HomeEvent {
  RemoveNavEvent();
}
