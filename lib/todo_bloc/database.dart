import 'dart:async';
import 'package:floor/floor.dart';

import 'todo.dart';
import 'todo_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Todo])
abstract class AppDatabase2 extends FloorDatabase {
  TodoDao get todoDao;
}
