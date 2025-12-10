import 'package:task_6/core/usecase/usecase.dart';
import 'package:task_6/feature/domain/product.dart';
import 'package:task_6/feature/domain/product_repository.dart';

class ViewAllProductsUseCase
    implements UseCase<List<Product>, NoParams> {
  final ProductRepository repository;

  ViewAllProductsUseCase(this.repository);

  @override
  Future<List<Product>> call(NoParams params) async {
    return repository.viewAllProducts();
  }
}