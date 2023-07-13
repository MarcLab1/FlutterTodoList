import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/todo_bloc/detail_bloc/detail_bloc_bloc.dart';
import 'package:my_app/todo_bloc/todo.dart';
import 'package:my_app/todo_bloc/todoRepository.dart';

class DetailScreen extends StatefulWidget {
  final TodoRepository repo;
  const DetailScreen({super.key, required this.repo});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  //ideally evey screen should have it's own bloc, and you shouldn't reuse them from screen to screen

  @override
  Widget build(BuildContext context) {
    final detailBloc = DetailBloc(widget.repo);

    var map = ModalRoute.of(context)?.settings.arguments;
    if (map is! Todo) return Container();
    Todo? _todo = map;

    detailBloc.add(InitialEvent2(todo: _todo!));

    return BlocConsumer<DetailBloc, DetailState>(
        bloc: detailBloc,
        listenWhen: (previous, current) => current is DetailActionState,
        buildWhen: (previous, current) => current is! DetailActionState,
        listener: (context, state) {
          if (state is NavigateToHomeScreenActionState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          switch (state.runtimeType) {
            case DetailLoadedState:
              {
                final _controller = TextEditingController();
                _controller.text = _todo.name;

                return Scaffold(
                    appBar: AppBar(
                        automaticallyImplyLeading: true,
                        backgroundColor: Colors.green.shade700,
                        actions: [
                          IconButton(
                              onPressed: () {
                                detailBloc.add(UpdateTodoEvent(
                                    todo: Todo(
                                  _todo.id,
                                  _controller.text,
                                  DateTime.now().millisecondsSinceEpoch,
                                  todoStatus: _todo.todoStatus,
                                )));
                              },
                              icon: Icon(Icons.save)),
                        ]),
                    body: ListTile(
                      subtitle: Text(_todo.getDateFormatted()),
                      title: TextField(controller: _controller),
                      trailing: IconButton(
                          onPressed: () {
                            detailBloc.add(DeleteTodoEvent(todo: _todo!));
                          },
                          icon: Icon(Icons.delete)),
                    ));
              }
            default:
              return Text("default error?");
          }
        });
  }
}
