import 'dart:math';

import 'package:floor/floor.dart';
import 'package:my_app/person_mvvm/person.dart';
import 'package:my_app/person_mvvm/person_dao.dart';
import 'database.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database =
      await $FloorAppDatabase.databaseBuilder('flutter_database7.db').build();
  final dao = database.personDao;

  runApp(FloorApp(personDao: dao));
}

class ColorHelper {
  static PersonColor _getNextColor(PersonColor color) {
    switch (color) {
      case PersonColor.blue:
        return PersonColor.red;
      case PersonColor.red:
        return PersonColor.green;
      case PersonColor.green:
        return PersonColor.blue;
    }
  }

  static PersonColor _getRamdomColor() {
    var num = Random().nextInt(3);
    switch (num) {
      case 0:
        return PersonColor.blue;
      case 1:
        return PersonColor.red;
      case 2:
        return PersonColor.green;
    }
    return PersonColor.blue;
  }

  static Color _getColorFromPersonColor(PersonColor color) {
    switch (color) {
      case PersonColor.blue:
        return Colors.blue;
      case PersonColor.red:
        return Colors.red;
      case PersonColor.green:
        return Colors.green;
    }
  }
}

class FloorApp extends StatefulWidget {
  final PersonDao personDao;

  FloorApp({super.key, required this.personDao});

  @override
  State<FloorApp> createState() => _FloorAppState();
}

class _FloorAppState extends State<FloorApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(personDao: widget.personDao),
        '/details': (context) => DetailScreen(personDao: widget.personDao),
      },
    );
  }
}

class DetailScreen extends StatefulWidget {
  final PersonDao personDao;
  DetailScreen({super.key, required this.personDao});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  PersonViewModel vm = PersonViewModel(repo: PersonRepository());

  @override
  Widget build(BuildContext context) {
    //we are just passing the id
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
        appBar: AppBar(),
        body: Column(children: [
          StreamBuilder(
              stream: widget.personDao.findPersonById(id),
              builder: (_, snapshot) {
                if (!snapshot.hasData) return Container();
                final person = snapshot.data!;
                return ListTile(
                    textColor:
                        ColorHelper._getColorFromPersonColor(person.color),
                    onTap: () {
                      setState(() {
                        /*
                        widget.personDao.updatePerson(Person(
                            person.id, person.name,
                            color: ColorHelper._getNextColor(person.color)));
                      });
                      */
                        vm.updatePerson(Person(person.id, person.name,
                            color: ColorHelper._getNextColor(person.color)));
                      });
                    },
                    title: Text(
                      snapshot.data.toString(),
                    ));
              })
        ]));
  }
}

class HomeScreen extends StatefulWidget {
  final PersonDao personDao;
  const HomeScreen({super.key, required this.personDao});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;
  Random rando = Random();
  PersonViewModel vm = PersonViewModel(repo: PersonRepository());
  late TextEditingController _controller = TextEditingController();

  void removeAllPersons() async {
    await widget.personDao.removeAllPersons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Center(
            child: StreamBuilder(
                stream: vm
                    .findPeopleCountStream(), //widget.personDao.findPeopleCountAsStream(),
                builder: (_, snapshot) {
                  int count = snapshot.data ?? 0;
                  return Text('$count');
                }),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    widget.personDao.insertPerson(Person(
                        _counter++, _controller.text,
                        color: ColorHelper._getRamdomColor()));
                  });
                  _controller.clear();
                },
                icon: Icon(Icons.add))
          ],
          title: TextField(
            decoration: InputDecoration(filled: true, fillColor: Colors.white),
            controller: _controller,
          ),
        ),
        floatingActionButton: CircleAvatar(
          backgroundColor: Colors.pink,
          child: IconButton(
              color: Colors.white,
              onPressed: () {
                setState(() {
                  _counter = 0;
                  removeAllPersons();
                });
              },
              icon: Icon(Icons.remove)),
        ),
        body: StreamBuilder(
            stream: vm
                .findAllPeopleStream(), //widget.personDao.findAllPeopleAsStream(),
            builder: (_, snapshot) {
              final people = snapshot.data;

              return ListView.builder(
                itemCount: people!.length,
                itemBuilder: (context, index) {
                  final Person person = people[index];
                  return ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, '/details',
                            arguments: person.id);
                      },
                      textColor:
                          ColorHelper._getColorFromPersonColor(person.color),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            widget.personDao
                                .deletePerson(snapshot.data![index]);
                          });
                        },
                      ),
                      title: Text("$index : ${people[index]}"));
                },
              );
            }));
  }
}

class PersonRepository {
  final databaseProvider = DatabaseService();

  Future<AppDatabase> getAppDatabase() async {
    return await databaseProvider.database;
  }

  Future<List<Person>> findAllPeople() async {
    final db = await databaseProvider.database;
    return db.personDao.findAllPeople();
  }

  Stream<List<Person>> findAllPeopleAsStream() async* {
    final db = await databaseProvider.database;
    yield* db.personDao.findAllPeopleAsStream();
  }

  Stream<int?> findPeopleCountAsStream() async* {
    final db = await databaseProvider.database;
    yield* db.personDao.findPeopleCountAsStream();
  }

  void updatePerson(Person person) async {
    final db = await databaseProvider.database;
    return db.personDao.updatePerson(person);
  }
}

class DatabaseService {
  DatabaseService._() {
    initDatabase();
  }
  static DatabaseService? _instance;

  factory DatabaseService() {
    if (_instance == null) {
      _instance = DatabaseService._();
    }
    return _instance!;
  }

  static AppDatabase? _database = null;
  Future<AppDatabase> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<AppDatabase> initDatabase() async {
    return await $FloorAppDatabase
        .databaseBuilder('flutter_database7.db')
        .build();
  }
}

class PersonViewModel with ChangeNotifier {
  final PersonRepository repo;
  PersonViewModel({required this.repo});

  Stream<List<Person>> findAllPeopleStream() async* {
    yield* repo.findAllPeopleAsStream();
  }

  Stream<int?> findPeopleCountStream() async* {
    yield* repo.findPeopleCountAsStream();
  }

  void updatePerson(Person person) {
    return repo.updatePerson(person);
  }
}
