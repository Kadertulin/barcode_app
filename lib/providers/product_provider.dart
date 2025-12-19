import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  final _db = DatabaseHelper.instance;

  List<Product> products = [];
  Product? searchedProduct;

  // READ: All
  Future<void> loadProducts() async {
    products = await _db.getAllProducts();
    searchedProduct = null;
    notifyListeners();
  }

  // READ: By barcode
  Future<Product?> searchByBarcode(String barcode) async {
    final p = await _db.getProductByBarcode(barcode);
    searchedProduct = p;
    notifyListeners();
    return p;
  }

  // CREATE
  Future<String?> addProduct(Product p) async {
    try {
      await _db.insertProduct(p);
      await loadProducts();
      return null;
    } catch (_) {
      return 'Bu barkod zaten kayıtlı.';
    }
  }

  // UPDATE
  Future<String?> updateProduct(Product p) async {
    try {
      await _db.updateProduct(p);
      await loadProducts();
      return null;
    } catch (_) {
      return 'Güncelleme başarısız.';
    }
  }

  // DELETE
  Future<String?> deleteProduct(String barcode) async {
    try {
      await _db.deleteProduct(barcode);
      await loadProducts();
      return null;
    } catch (_) {
      return 'Silme başarısız.';
    }
  }
}
