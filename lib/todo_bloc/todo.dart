import 'package:floor/floor.dart';
import 'package:intl/intl.dart';

@entity
class Todo {
  @primaryKey
  final int id;
  final String name;
  final int dateTime;
  final TodoStatus todoStatus;
  final bool isDone;
  Todo(this.id, this.name, this.dateTime,
      {this.todoStatus = TodoStatus.notcompleted, this.isDone = false});

  @override
  String toString() {
    return "$id - $name ${_dateFormatter(dateTime)}";
  }

  String _dateFormatter(int dateTime) {
    var date = DateTime.fromMillisecondsSinceEpoch(dateTime);
    final DateFormat formatter = DateFormat('yyyy-MM-dd H:m');

    return formatter.format(date);
  }

  String getDateFormatted() {
    return _dateFormatter(dateTime);
  }
}

enum TodoStatus {
  completed('Completed'),
  notcompleted('Not completed'),

  //I don't use this right now
  cancelled('Cancelled');

  final String status;

  const TodoStatus(this.status);
}
