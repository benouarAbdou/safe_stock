import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await intialDb();
      return _db;
    } else {
      return _db;
    }
  }

  intialDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'stock.db');
    Database mydb = await openDatabase(path,
        onCreate: _onCreate,
        version: 3,
        onUpgrade: _onUpgrade,
        onOpen: _onOpen);
    return mydb;
  }

  _onUpgrade(Database db, int oldversion, int newversion) async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'stock.db');

    print(path);
    print("onUpgrade =====================================");
  }

  _onOpen(Database db) async {
    await db.execute("PRAGMA foreign_keys = ON");
  }

  _onCreate(Database db, int version) async {
    await db.execute("PRAGMA foreign_keys = ON");

    await db.execute('''
    CREATE TABLE "user" (
      "userId" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "userName" TEXT NOT NULL,
      "userPassword" TEXT NOT NULL,
      "userType" INTEGER NOT NULL
    )
  ''');
    print("user table created");

    await db.execute('''
    CREATE TABLE "fournisseur" (
      "fournisseurId" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "fournisseurName" TEXT NOT NULL,
      "fournisseurNtel" TEXT,
      "fournisseurAdresse" TEXT,
      "fournisseurTotale" REAL DEFAULT 0
    )
  ''');
    print("fournisseur table created");

    await db.execute('''
    CREATE TABLE "client" (
      "clientId" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "clientName" TEXT NOT NULL,
      "clientNtel" TEXT,
      "clientAdresse" TEXT,
      "clientTotale" REAL DEFAULT 0 
    )
  ''');
    print("client table created");

    await db.execute('''
    CREATE TABLE "produit" (
      "produitId" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "produitNom" TEXT NOT NULL,
      "codebar" TEXT ,
      "produitPrix" REAL NOT NULL,
      "prixAchat" REAL NOT NULL,
      "produitQuantité" REAL NOT NULL,
      "userId" INTEGER NOT NULL,
      FOREIGN KEY ("userId") REFERENCES "user" ("userId") ON UPDATE CASCADE ON DELETE CASCADE
    )
  ''');
    print("produit table created");

    await db.execute('''
    CREATE TABLE "operationAchat" (
      "operationAchatId" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,    
      "fournisseurId" INTEGER NOT NULL,
      "userId" INTEGER NOT NULL,
      "virement" REAL NOT NULL,
      "totale" REAL NOT NULL,
      "timestamp" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY ("fournisseurId") REFERENCES "fournisseur" ("fournisseurId") ON UPDATE CASCADE ON DELETE CASCADE,
      FOREIGN KEY ("userId") REFERENCES "user" ("userId") ON UPDATE CASCADE ON DELETE CASCADE
    )
  ''');
    print("achat table created");

    await db.execute('''
    CREATE TABLE "achat" (
      "achatId" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "produitId" INTEGER NOT NULL,
      "operationAchatId" INTEGER NOT NULL,
      "fournisseurId" INTEGER NOT NULL,
      "quantité" REAL NOT NULL,
      "prix" REAL NOT NULL,
      "totale" REAL NOT NULL,
      "timestamp" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY ("produitId") REFERENCES "produit" ("produitId") ON UPDATE CASCADE ON DELETE CASCADE,
      FOREIGN KEY ("operationAchatId") REFERENCES "operationAchat" ("operationAchatId") ON UPDATE CASCADE ON DELETE CASCADE,
      FOREIGN KEY ("fournisseurId") REFERENCES "fournisseur" ("fournisseurId") ON UPDATE CASCADE ON DELETE CASCADE
      
    )
  ''');
    print("achat table created");

    await db.execute('''
    CREATE TABLE "vente" (
      "venteId" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "clientId" INTEGER NOT NULL,
      "userId" INTEGER NOT NULL,
      "totale" REAL NOT NULL,
      "timestamp" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY ("clientId") REFERENCES "client" ("clientId") ON UPDATE CASCADE ON DELETE CASCADE,
      FOREIGN KEY ("userId") REFERENCES "user" ("userId") ON UPDATE CASCADE ON DELETE CASCADE
    )
  ''');
    print("vente table created");

    /*await db.execute('''
    CREATE TABLE "creditClient" (
      "creditClientId" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "clientId" INTEGER NOT NULL,
      "venteId" INTEGER NOT NULL,
      "totale" INTEGER NOT NULL,
      FOREIGN KEY ("clientId") REFERENCES "client" ("clientId") ON UPDATE CASCADE ON DELETE CASCADE,
      FOREIGN KEY ("venteId") REFERENCES "vente" ("venteId") ON UPDATE CASCADE ON DELETE CASCADE
    )
  ''');
    print("creditClient table created");

    await db.execute('''
    CREATE TABLE "creditFournisseur" (
      "creditFournisseurId" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "fournisseurId" INTEGER NOT NULL,
      "achatId" INTEGER NOT NULL,
      "totale" INTEGER NOT NULL,
      FOREIGN KEY ("fournisseurId") REFERENCES "fournisseur" ("fournisseurId") ON UPDATE CASCADE ON DELETE CASCADE,
      FOREIGN KEY ("achatId") REFERENCES "achat" ("achatId") ON UPDATE CASCADE ON DELETE CASCADE
    )
  ''');
    print("creditFournisseur table created");*/

    print("onCreate =====================================");
  }

  readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

// SELECT
// DELETE
// UPDATE
// INSERT
}
