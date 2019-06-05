import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_app/model/client_model.dart';
import 'package:sqflite/sql.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart';

class ClientDatabaseProvider{


  ClientDatabaseProvider._();

  static final ClientDatabaseProvider db = ClientDatabaseProvider._();
  Database _database;

  // para evitar que abra conexiuones una y otra vez podemos usar algo como est..

  Future<Database> get database async {
      if(_database != null ) return  _database;

      _database = await getDatabaseInstance();

      return _database;

  }


  Future<Database> getDatabaseInstance() async{

    Directory directory = await getApplicationDocumentsDirectory();

    String path = join( directory.path , "client.db" );

    return await  openDatabase(path, version: 1,
        onCreate: (Database db , int version ) async {
              await  db.execute("CREATE TABLE Client ("
                  "id integer primary key , "
                  "name TEXT, "
                  "phone TEXT, "
                  " ) ");
        } );


  }// future


  // query
  // muestra todos los clientes de la base de datos
  Future<List<Client>> getAllClients() async{

      final db = await database;
      var response = await db.query("Client");

      List<Client> list = response.map( (c) => Client.fromMap(c) ).toList();

      return list;


  }



  // muestra todos 1 cliente de la base de datos por el id
  Future<Client> getClientWithId(int id) async{

    final db = await database;
    var response = await db.query("Client",where: "id = ? " ,  whereArgs: [id] );

    // List<Client> list = response.map( (c) => Client.fromMap(c) ).toList();

    return response.isNotEmpty ? Client.fromMap(response.first) : null;


  }

  addClientToData(Client client) async{
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 from Client");

    int id = table.first["id"];
    client.id = id;

    var raw = await db.insert(
      "Client",
      client.toMap() ,
      conflictAlgorithm: ConflictAlgorithm.replace ,
    );

    return raw;



  }// Insert / Add Client



  // Delete
  // delete client with id
  deleteClientWithId(int id) async{

    final db = await database;
    return db.delete("Client" , where: "id = ? " , whereArgs: [id] );

  } // deleteClientWithId

  // delete all cliens
  deleteAllClient() async{

    final db = await database;
    db.delete("Client");

  } // delete all clients

  updateClient(Client client) async{

    final db = await database;
    var response = await db.update("Client", client.toMap() , where: "id = ? " , whereArgs: [client.id]  );

    return response;

  } // updateClient



}