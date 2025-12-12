import 'package:task_6/core/usecase/usecase.dart';
import 'package:task_6/feature/domain/entities/product.dart';
import 'package:task_6/feature/domain/product_repository.dart';

class UpdateProductUseCase implements UseCase<void, Product> {
  final ProductRepository repository;

  UpdateProductUseCase(this.repository);

  @override
  Future<void> call(Product product) async {
    repository.updateProduct(product);
  }
}