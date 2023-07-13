import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../todo.dart';
import '../todoRepository.dart';

part 'detail_bloc_event.dart';
part 'detail_bloc_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final TodoRepository _todoRepository;
  List<Todo> todos = List.empty();

  DetailBloc(this._todoRepository) : super(InitialState2()) {
    on<InitialEvent2>(initialEvent);
    on<DeleteTodoEvent>(deleteTodoEvent);
    on<UpdateTodoEvent>(updateTodoEvent);
    on<NavigateToHomeScreenEvent>(navigateToHomeScreenEvent);
  }

  FutureOr<void> initialEvent(
      InitialEvent2 event, Emitter<DetailState> emit) async {
    try {
      emit(DetailLoadedState(todo: event.todo));
    } catch (e) {
      emit(DetailErrorState(error: e.toString()));
    }
  }

  FutureOr<void> deleteTodoEvent(
      DeleteTodoEvent event, Emitter<DetailState> emit) async {
    await _todoRepository.deleteTodo(event.todo);
    emit(NavigateToHomeScreenActionState());
  }

  FutureOr<void> navigateToHomeScreenEvent(
      NavigateToHomeScreenEvent event, Emitter<DetailState> emit) {
    emit(NavigateToHomeScreenActionState());
  }

  FutureOr<void> updateTodoEvent(
      UpdateTodoEvent event, Emitter<DetailState> emit) async {
    await _todoRepository.updateTodo(event.todo);
    emit(NavigateToHomeScreenActionState());
  }
}
