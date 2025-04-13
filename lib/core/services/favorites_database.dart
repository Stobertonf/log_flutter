import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/pokemon_model.dart';

class FavoritesDatabase {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'favorites.db');

    await deleteDatabase(path);

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE favorites (
            id INTEGER PRIMARY KEY,
            name TEXT,
            height INTEGER,
            weight INTEGER,
            types TEXT,
            abilities TEXT,
            imageUrl TEXT,
            stats TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insert(PokemonModel pokemon) async {
    final db = await database;
    await db.insert(
      'favorites',
      pokemon.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<PokemonModel>> getAll() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    return maps.map((map) => PokemonModel.fromMap(map)).toList();
  }

  static Future<void> delete(int id) async {
    final db = await database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  static Future<bool> isFavorited(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }
}
