import 'package:floor/floor.dart';

@entity
class Person {
  @primaryKey
  final int id;
  final String name;
  final PersonColor color;

  Person(this.id, this.name, {this.color = PersonColor.blue});

  @override
  String toString() {
    return "$id - $name - $color";
  }
}

enum PersonColor {
  red('Green'),
  blue('Blueeee'),
  green('Green');

  final String color;
  const PersonColor(this.color);
}
