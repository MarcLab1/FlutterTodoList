// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase2 {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabase2Builder databaseBuilder(String name) =>
      _$AppDatabase2Builder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabase2Builder inMemoryDatabaseBuilder() =>
      _$AppDatabase2Builder(null);
}

class _$AppDatabase2Builder {
  _$AppDatabase2Builder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabase2Builder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabase2Builder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase2> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase2();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase2 extends AppDatabase2 {
  _$AppDatabase2([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TodoDao? _todoDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Todo` (`id` INTEGER NOT NULL, `name` TEXT NOT NULL, `dateTime` INTEGER NOT NULL, `todoStatus` INTEGER NOT NULL, `isDone` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TodoDao get todoDao {
    return _todoDaoInstance ??= _$TodoDao(database, changeListener);
  }
}

class _$TodoDao extends TodoDao {
  _$TodoDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _todoInsertionAdapter = InsertionAdapter(
            database,
            'Todo',
            (Todo item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'dateTime': item.dateTime,
                  'todoStatus': item.todoStatus.index,
                  'isDone': item.isDone ? 1 : 0
                },
            changeListener),
        _todoUpdateAdapter = UpdateAdapter(
            database,
            'Todo',
            ['id'],
            (Todo item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'dateTime': item.dateTime,
                  'todoStatus': item.todoStatus.index,
                  'isDone': item.isDone ? 1 : 0
                },
            changeListener),
        _todoDeletionAdapter = DeletionAdapter(
            database,
            'Todo',
            ['id'],
            (Todo item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'dateTime': item.dateTime,
                  'todoStatus': item.todoStatus.index,
                  'isDone': item.isDone ? 1 : 0
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Todo> _todoInsertionAdapter;

  final UpdateAdapter<Todo> _todoUpdateAdapter;

  final DeletionAdapter<Todo> _todoDeletionAdapter;

  @override
  Future<List<Todo>> getTodos() async {
    return _queryAdapter.queryList('SELECT * FROM Todo',
        mapper: (Map<String, Object?> row) => Todo(
            row['id'] as int, row['name'] as String, row['dateTime'] as int,
            todoStatus: TodoStatus.values[row['todoStatus'] as int],
            isDone: (row['isDone'] as int) != 0));
  }

  @override
  Stream<List<Todo>> getTodosStream() {
    return _queryAdapter.queryListStream('SELECT * FROM Todo',
        mapper: (Map<String, Object?> row) => Todo(
            row['id'] as int, row['name'] as String, row['dateTime'] as int,
            todoStatus: TodoStatus.values[row['todoStatus'] as int],
            isDone: (row['isDone'] as int) != 0),
        queryableName: 'Todo',
        isView: false);
  }

  @override
  Future<void> deleteAllTodos() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Todo');
  }

  @override
  Stream<int?> getTodoCountStream() {
    return _queryAdapter.queryStream('SELECT DISTINCT COUNT(id) FROM Todo',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        queryableName: 'Todo',
        isView: false);
  }

  @override
  Future<int?> getTodoCount() async {
    return _queryAdapter.query('SELECT DISTINCT COUNT(id) FROM Todo',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getMaxTodoId() async {
    return _queryAdapter.query('SELECT MAX(id) FROM Todo',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<List<Todo>> getTodosLike(String name) async {
    return _queryAdapter.queryList('SELECT * FROM Todo WHERE name LIKE ?1',
        mapper: (Map<String, Object?> row) => Todo(
            row['id'] as int, row['name'] as String, row['dateTime'] as int,
            todoStatus: TodoStatus.values[row['todoStatus'] as int],
            isDone: (row['isDone'] as int) != 0),
        arguments: [name]);
  }

  @override
  Future<void> insertTodo(Todo todo) async {
    await _todoInsertionAdapter.insert(todo, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    await _todoUpdateAdapter.update(todo, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTodo(Todo todo) async {
    await _todoDeletionAdapter.delete(todo);
  }
}
