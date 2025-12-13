import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_6/core/error/exceptions.dart';
import 'package:task_6/feature/data/datasources/product_local_data_source.dart';
import 'package:task_6/feature/data/models/product_model.dart';

class ProductLocalDatasourceImpl implements ProductLocalDataSource {
  static const String cachedProductsKey = 'CACHED_PRODUCTS';

  final SharedPreferences sharedPreferences;

  const ProductLocalDatasourceImpl({required this.sharedPreferences});

  // -------- Helpers --------
  Future<List<ProductModel>> _readAll() async {
    final jsonString = sharedPreferences.getString(cachedProductsKey);
    if (jsonString == null) {
      throw CacheException('No cached products found');
    }

    final decoded = jsonDecode(jsonString);
    if (decoded is! List) {
      throw CacheException('Corrupted cache format (expected List)');
    }

    try {
      return decoded
          .map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(growable: false);
    } catch (_) {
      throw CacheException('Corrupted cache content');
    }
  }

  Future<void> _writeAll(List<ProductModel> products) async {
    final list = products.map((p) => p.toJson()).toList(growable: false);
    final encoded = jsonEncode(list);

    final ok = await sharedPreferences.setString(cachedProductsKey, encoded);
    if (!ok) {
      throw CacheException('Failed to cache products');
    }
  }

  // -------- Interface methods --------
  @override
  Future<List<ProductModel>> getCachedAll() async {
    return _readAll();
  }

  @override
  Future<ProductModel?> getCachedOne(String id) async {
    final all = await _readAll();
    try {
      return all.firstWhere((p) => p.id == id);
    } catch (_) {
      return null; 
    }
  }

  @override
  Future<void> cacheAll(List<ProductModel> products) async {
    await _writeAll(products);
  }

  @override
  Future<void> cacheOne(ProductModel product) async {
    List<ProductModel> all = <ProductModel>[];
    try {
      all = await _readAll();
    } catch (_) {
      all = <ProductModel>[];
    }

    final updated = [
      for (final p in all)
        if (p.id == product.id) product else p
    ];

    final exists = all.any((p) => p.id == product.id);
    final finalList = exists ? updated : [...all, product];

    await _writeAll(finalList);
  }

  @override
  Future<void> removeCached(String id) async {
    final all = await _readAll();
    final newList = all.where((p) => p.id != id).toList(growable: false);
    await _writeAll(newList);
  }
}