import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/todo_bloc/todo.dart';
import 'package:my_app/todo_bloc/todoRepository.dart';

import 'home_bloc/home_bloc_bloc.dart';
import 'home_bloc/home_bloc_events.dart';
import 'home_bloc/home_bloc_state.dart';

class HomeScreen extends StatefulWidget {
  final TodoRepository repo;
  HomeScreen({super.key, required this.repo});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeBloc = HomeBloc(TodoRepository());
  int _counter = 1;

  @override
  void initState() {
    homeBloc.add(InitialEvent());
    //populateCounter();
    super.initState();
  }

  void populateCounter() async {
    int? _max = await widget.repo.getMaxTodoId();
    if (_max != null) _counter = _max! + 1;
  }

  showAlertDialog(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    FocusNode focusNode = FocusNode();
    focusNode.requestFocus();

    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Add Todo"),
      onPressed: () {
        homeBloc.add(AddTodoEvent(Todo(
            _counter++, _controller.text, DateTime.now().millisecondsSinceEpoch,
            todoStatus: TodoStatus.notcompleted, isDone: false)));
        _controller.clear();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Add Todo"),
      content: TextField(
          focusNode: focusNode,
          controller: _controller,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.0)),
              hintText: 'Enter your todo')),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
        bloc: homeBloc,
        listenWhen: (previous, current) => current is TodoActionState,
        buildWhen: (previous, current) => current is! TodoActionState,
        listener: (context, state) {
          if (state is NavigateToTodoDetailScreenActionState) {
            Navigator.pushNamed(context, '/detail', //navigating with arguments
                arguments: state.todo);
          }
          homeBloc.add(RemoveNavEvent());
        },
        builder: (context, state) {
          const data = "No todos yet";
          switch (state.runtimeType) {
            case HomeLoadingState:
              return const Center(
                  heightFactor: 50,
                  widthFactor: 50,
                  child: CircularProgressIndicator());

            case HomeLoadedState:
              final HomeLoadedState newState = state as HomeLoadedState;
              final List<Todo> todos = newState.todos;

              return Scaffold(
                floatingActionButton: IconButton(
                  onPressed: () {
                    showAlertDialog(context);
                  },
                  icon: Icon(Icons.add_circle_outline),
                ),
                appBar: AppBar(
                  backgroundColor: Colors.green.shade700,
                  title: Center(child: Text("Todo App")),
                  automaticallyImplyLeading: false,
                ),
                body: (todos.length == 0)
                    ? const Center(
                        child: Text(data),
                      )
                    : ListView.builder(
                        itemCount: todos.length,
                        itemBuilder: (context, index) {
                          final Todo todo = todos[index];
                          final textStyle =
                              (todo.todoStatus == TodoStatus.completed)
                                  ? TextStyle(
                                      decoration: TextDecoration.lineThrough)
                                  : TextStyle();

                          return Dismissible(
                              key: UniqueKey(),
                              onDismissed: (direction) {
                                homeBloc.add(DeleteTodoEvent(todo: todo));

                                final snackBar = SnackBar(
                                    content: Text('Todo deleted'),
                                    action: SnackBarAction(
                                        label: "UNDO",
                                        onPressed: () {
                                          homeBloc.add(AddTodoEvent(todo));
                                        }));

                                ScaffoldMessenger.of(context)
                                    .removeCurrentSnackBar();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              },
                              child: ListTile(
                                  leading: Checkbox(
                                    shape: CircleBorder(),
                                    fillColor: MaterialStateColor.resolveWith(
                                        (states) => Colors.green.shade700),
                                    value: (todo.todoStatus ==
                                            TodoStatus.completed)
                                        ? true
                                        : false,
                                    onChanged: (value) {
                                      homeBloc.add(UpdateTodoEvent(
                                          todo: Todo(
                                              todo.id,
                                              todo.name,
                                              DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              todoStatus: (todo.todoStatus ==
                                                      TodoStatus.completed)
                                                  ? TodoStatus.notcompleted
                                                  : TodoStatus.completed)));
                                    },
                                  ),
                                  onTap: () {
                                    homeBloc.add(NavigateToDetailScreenEvent(
                                        todo: todos[index]));
                                  },
                                  title: Text(todo.name, style: textStyle),
                                  subtitle: Text(todo.getDateFormatted(),
                                      style: textStyle)));
                        },
                      ),
              );
            case HomeErrorState:
              return Text("error");
            default:
              return Text("default error?");
          }
        });
  }
}
