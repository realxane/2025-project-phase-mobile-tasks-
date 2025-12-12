import 'entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> viewAllProducts();
  Future<Product?> viewProduct(String id);
  Future<void> createProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String id);
}