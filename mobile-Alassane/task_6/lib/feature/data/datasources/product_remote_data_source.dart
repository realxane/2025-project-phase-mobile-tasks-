import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchAll();
  Future<ProductModel> fetchOne(String id);
  Future<void> create(ProductModel product);
  Future<void> update(ProductModel product);
  Future<void> delete(String id);
}