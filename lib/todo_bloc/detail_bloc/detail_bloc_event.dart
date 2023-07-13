part of 'detail_bloc_bloc.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();

  @override
  List<Object> get props => [];
}

class InitialEvent2 extends DetailEvent {
  final Todo todo;
  InitialEvent2({required this.todo});
}

class DeleteTodoEvent extends DetailEvent {
  final Todo todo;
  DeleteTodoEvent({required this.todo});
}

class UpdateTodoEvent extends DetailEvent {
  final Todo todo;
  UpdateTodoEvent({required this.todo});
}

class NavigateToHomeScreenEvent extends DetailEvent {
  NavigateToHomeScreenEvent();
}
