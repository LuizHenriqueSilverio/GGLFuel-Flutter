import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/fuel_register.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('fuelRegistry.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE fuel_registry ( 
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      fuel_qty REAL, 
      fuel_price REAL
    )
    ''');
  }

  Future<int> create(FuelRegister register) async {
    final db = await instance.database;
    return await db.insert('fuel_registry', register.toMap());
  }

  Future<List<FuelRegister>> readAllRegisters() async {
    final db = await instance.database;
    final result = await db.query('fuel_registry');

    return result.map((json) => FuelRegister.fromMap(json)).toList();
  }

  Future<int> update(FuelRegister register) async {
    final db = await instance.database;
    return db.update(
      'fuel_registry',
      register.toMap(),
      where: 'id = ?',
      whereArgs: [register.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete('fuel_registry', where: 'id = ?', whereArgs: [id]);
  }
}
