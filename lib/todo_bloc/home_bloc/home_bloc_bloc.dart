import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../todo.dart';
import '../todoRepository.dart';
import 'home_bloc_events.dart';
import 'home_bloc_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final TodoRepository _todoRepository;
  List<Todo> _todos = List.empty();

  HomeBloc(this._todoRepository) : super(InitialState()) {
    on<StreamUpdatedEvent>(streamUpdatedEvent);
    on<InitialEvent>(initialEvent);
    on<AddTodoEvent>(addTodoEvent);
    on<UpdateTodoEvent>(updateTodoEvent);
    on<DeleteTodoEvent>(deleteTodoEvent);
    on<DeleteAllTodosEvent>(deleteAllTodosEvent);
    on<NavigateToDetailScreenEvent>(navigateToDetailScreenEvent);
    on<RemoveNavEvent>(removeNavEvent);
  }

  void listenToStream() async {
    await _todoRepository.getTodosStream().listen(
      (todos) {
        _todos = todos;
        add(StreamUpdatedEvent(todos: todos));
      },
      onError: (error) {},
    );
  }

  FutureOr<void> initialEvent(
      InitialEvent event, Emitter<HomeState> emit) async {
    try {
      emit(HomeLoadingState());
      await Future.delayed(Duration(seconds: 1));
      listenToStream();
    } catch (e) {
      emit(HomeErrorState(error: e.toString()));
    }
  }

  FutureOr<void> addTodoEvent(
      AddTodoEvent event, Emitter<HomeState> emit) async {
    try {
      await _todoRepository.insertTodo(event.todo);
    } catch (e) {
      emit(HomeErrorState(error: e.toString()));
    }
  }

  FutureOr<void> navigateToDetailScreenEvent(
      NavigateToDetailScreenEvent event, Emitter<HomeState> emit) {
    emit(NavigateToTodoDetailScreenActionState(todo: event.todo));
  }

  FutureOr<void> deleteAllTodosEvent(
      DeleteAllTodosEvent event, Emitter<HomeState> emit) async {
    try {
      await _todoRepository.deleteAllTodos();
    } catch (e) {
      emit(HomeErrorState(error: e.toString()));
    }
  }

  FutureOr<void> deleteTodoEvent(
      DeleteTodoEvent event, Emitter<HomeState> emit) async {
    try {
      await _todoRepository.deleteTodo(event.todo);
    } catch (e) {
      emit(HomeErrorState(error: e.toString()));
    }
  }

  FutureOr<void> removeNavEvent(RemoveNavEvent event, Emitter<HomeState> emit) {
    emit(HomeLoadedState(todos: _todos));
  }

  FutureOr<void> streamUpdatedEvent(
      StreamUpdatedEvent event, Emitter<HomeState> emit) {
    emit(HomeLoadedState(todos: event.todos));
  }

  FutureOr<void> updateTodoEvent(
      UpdateTodoEvent event, Emitter<HomeState> emit) async {
    await _todoRepository.updateTodo(event.todo);
    //emit(NavigateToHomeScreenActionState());
  }
}
