part of 'detail_bloc_bloc.dart';

abstract class DetailState extends Equatable {
  const DetailState();

  @override
  List<Object> get props => [];
}

class InitialState2 extends DetailState {}

abstract class DetailActionState extends DetailState {}

class DetailLoadingState extends DetailState {}

class DetailLoadedState extends DetailState {
  final Todo todo;
  DetailLoadedState({required this.todo});
}

class DetailErrorState extends DetailState {
  final String error;
  DetailErrorState({required this.error});
}

class NavigateToHomeScreenActionState extends DetailActionState {
  NavigateToHomeScreenActionState();
}
