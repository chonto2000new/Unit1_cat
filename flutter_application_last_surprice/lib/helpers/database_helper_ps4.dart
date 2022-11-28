import 'package:flutter_application_last_surprice/models/cat_model.dart';
import 'package:flutter_application_last_surprice/models/ps4_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

//dos referencia para conectar a la base de datos
class DatabaseHelperps4 {
  DatabaseHelperps4._privateConstructor();
  //instance es poner el nombre que sea
  static final DatabaseHelperps4 instance =
      DatabaseHelperps4._privateConstructor();
  // el ? es para decir si es opcional por aqui tambien se ve si si esta la base de datos. si no existe la crea en la cosa que dice directory

  static Database? _database;
  //asincrono , que no jalan a la vez
  Future<Database> get database async => _database ??= await _initDatabase();
  Future<Database> _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path,
        "ps4.db"); //este es el que tiene al chiforinpula y el de arriba
    //open data base para brir la database
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

//esto crea ta tabla llamada gatos , pero si existe se lo salta
  Future _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE ps4 (
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
  Future<int> add(Ps4 ps4) async {
    Database db = await instance.database;
    return await db.insert("ps4", ps4.toMap());
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete('ps4', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Ps4 ps4) async {
    Database db = await instance.database;
    return await db
        .update('ps4', ps4.toMap(), where: 'id=?', whereArgs: [ps4.id]);
  }

  Future<List<Ps4>> getPS4s() async {
    Database db = await instance.database;
    var ps4 = await db.query("ps4", orderBy: "price");
    List<Ps4> ps4List =
        //algo de que si esta basio que me regrese una lidata
        ps4.isNotEmpty ? ps4.map((e) => Ps4.fromMap(e)).toList() : [];
    return ps4List;
  }
}
