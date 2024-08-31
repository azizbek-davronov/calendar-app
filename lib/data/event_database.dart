// data/event_database.dart
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/event.dart';

class EventDatabase {
  static final EventDatabase instance = EventDatabase._init();
  static Database? _database;

  EventDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('events.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE events (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      subtitle TEXT NOT NULL,
      date TEXT NOT NULL
    )
    ''');
  }

  Future<Event> create(Event event) async {
    final db = await instance.database;
    final id = await db.insert('events', event.toMap());
    return event.copyWith(id: id);
  }

  Future<List<Event>> readAllEvents() async {
    final db = await instance.database;
    final result = await db.query('events', orderBy: 'date');
    return result.map((json) => Event.fromMap(json)).toList();
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete('events', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Event event) async {
    final db = await instance.database;
    return await db.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
