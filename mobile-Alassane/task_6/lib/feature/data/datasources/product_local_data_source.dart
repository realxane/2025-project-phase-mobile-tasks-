import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getCachedAll();
  Future<ProductModel?> getCachedOne(String id);

  Future<void> cacheAll(List<ProductModel> products);
  Future<void> cacheOne(ProductModel product);

  Future<void> removeCached(String id);
}