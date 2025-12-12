import 'package:task_6/feature/domain/entities/product.dart';

abstract class ProductRepository {
  List<Product> viewAllProducts();
  Product? viewProduct(String id);
  void createProduct(Product product);
  void updateProduct(Product product);
  void deleteProduct(String id);
}