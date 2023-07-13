import 'package:floor/floor.dart';

import 'person.dart';

@dao
abstract class PersonDao {
  @Query('SELECT * FROM Person')
  Future<List<Person>> findAllPeople();

  @Query('SELECT * FROM Person')
  Stream<List<Person>> findAllPeopleAsStream();

  @Query('SELECT DISTINCT COUNT(id) FROM Person')
  Stream<int?> findPeopleCountAsStream();

  @Query('SELECT name FROM Person')
  Stream<List<String>> findAllPeopleName();

  @Query('SELECT * FROM Person WHERE id = :id')
  Stream<Person?> findPersonById(int id);

  @insert
  Future<void> insertPerson(Person person);

  @Query('DELETE FROM Person')
  Future<void> removeAllPersons();

  @delete
  Future<void> deletePerson(Person person);

  @update
  Future<void> updatePerson(Person person);
}
