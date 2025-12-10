import 'package:task_6/core/usecase/usecase.dart';
import 'package:task_6/feature/domain/product_repository.dart';

class DeleteProductParams {
  final String id;
  const DeleteProductParams(this.id);
}

class DeleteProductUseCase implements UseCase<void, DeleteProductParams> {
  final ProductRepository repository;

  DeleteProductUseCase(this.repository);

  @override
  Future<void> call(DeleteProductParams params) async {
    repository.deleteProduct(params.id);
  }
}