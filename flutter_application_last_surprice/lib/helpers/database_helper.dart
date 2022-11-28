import 'package:flutter_application_last_surprice/models/cat_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

//dos referencia para conectar a la base de datos
class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  //instance es poner el nombre que sea
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  // el ? es para decir si es opcional por aqui tambien se ve si si esta la base de datos. si no existe la crea en la cosa que dice directory

  static Database? _database;
  //asincrono , que no jalan a la vez
  Future<Database> get database async => _database ??= await _initDatabase();
  Future<Database> _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path,
        "games.db"); //este es el que tiene al chiforinpula y el de arriba
    //open data base para brir la database
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

//esto crea ta tabla llamada gatos , pero si existe se lo salta
  Future _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE games (
  id INTEGER PRIMARY KEY,
  name TEXT, 
  price TEXT,
  console TEXT,
   genero TEXT,
  fotos TEXT    
  
)
''');
  }

  //para añadir mas gatos , es asincrona , como Yu Gi Oh
  Future<int> add(Cat cat) async {
    Database db = await instance.database;
    return await db.insert("games", cat.toMap());
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete('games', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Cat cat) async {
    Database db = await instance.database;
    return await db
        .update('games', cat.toMap(), where: 'id=?', whereArgs: [cat.id]);
  }

  Future<List<Cat>> getCats() async {
    Database db = await instance.database;
    var games = await db.query("games", orderBy: "price");
    List<Cat> castList =
        //algo de que si esta basio que me regrese una lidata
        games.isNotEmpty ? games.map((e) => Cat.fromMap(e)).toList() : [];
    return castList;
  }
}
