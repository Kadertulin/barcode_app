import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/product.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static const String _dbName = 'products.db';
  static const int _dbVersion = 1;

  static const String tableProducts = 'products';

  Database? _database;

  
  Future<Database> get db async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  
  Future<Database> _initDb() async {
    final dbFolder = await getDatabasesPath();
    final path = join(dbFolder, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableProducts(
        barcodeNo TEXT PRIMARY KEY,
        productName TEXT NOT NULL,
        category TEXT NOT NULL,
        unitPrice REAL NOT NULL,
        taxRate INTEGER NOT NULL,
        price REAL NOT NULL,
        stockInfo INTEGER
      )
    ''');
  }

  
  Future<int> insertProduct(Product product) async {
    final database = await db;
    return await database.insert(
      tableProducts,
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  
  Future<List<Product>> getAllProducts() async {
    final database = await db;
    final List<Map<String, dynamic>> result =
    await database.query(tableProducts);

    return result.map((e) => Product.fromMap(e)).toList();
  }

  
  Future<Product?> getProductByBarcode(String barcode) async {
    final database = await db;
    final result = await database.query(
      tableProducts,
      where: 'barcodeNo = ?',
      whereArgs: [barcode],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return Product.fromMap(result.first);
  }

  
  Future<int> updateProduct(Product product) async {
    final database = await db;
    return await database.update(
      tableProducts,
      product.toMap(),
      where: 'barcodeNo = ?',
      whereArgs: [product.barcodeNo],
    );
  }

  
  Future<int> deleteProduct(String barcode) async {
    final database = await db;
    return await database.delete(
      tableProducts,
      where: 'barcodeNo = ?',
      whereArgs: [barcode],
    );
  }
}
