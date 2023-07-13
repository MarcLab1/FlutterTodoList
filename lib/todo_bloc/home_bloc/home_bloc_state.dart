import 'package:flutter/material.dart';

import '../todo.dart';

@immutable
abstract class HomeState {}

abstract class TodoActionState extends HomeState {}

class InitialState extends HomeState {}

class HomeLoadingState extends HomeState {
  HomeLoadingState();
}

class HomeLoadedState extends HomeState {
  final List<Todo> todos;
  HomeLoadedState({required this.todos});
}

class HomeErrorState extends HomeState {
  final String error;
  HomeErrorState({required this.error});
}

class NavigateToTodoDetailScreenActionState extends TodoActionState {
  final Todo todo;
  NavigateToTodoDetailScreenActionState({required this.todo});
}

class RemoveNavState extends TodoActionState {}
