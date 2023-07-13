import 'package:flutter/material.dart';
import 'package:my_app/todo_bloc/todoRepository.dart';
import 'detail_screen.dart ';
import 'home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  TodoRepository _repo = TodoRepository();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomeScreen(repo: _repo),
        '/detail': (context) => DetailScreen(repo: _repo)
      },
    );
  }
}
