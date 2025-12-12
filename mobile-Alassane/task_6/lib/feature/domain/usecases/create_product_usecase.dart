import 'package:task_6/core/usecase/usecase.dart';
import 'package:task_6/feature/domain/entities/product.dart';
import 'package:task_6/feature/domain/product_repository.dart';

class CreateProductUseCase implements UseCase<void, Product> {
  final ProductRepository repository;

  CreateProductUseCase(this.repository);

  @override
  Future<void> call(Product product) async {
    repository.createProduct(product);
  }
}