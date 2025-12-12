import 'package:task_6/core/usecase/usecase.dart';
import 'package:task_6/feature/domain/entities/product.dart';
import 'package:task_6/feature/domain/product_repository.dart';

class ViewProductParams {
  final String id;
  const ViewProductParams(this.id);
}

class ViewProductUsecase
    implements UseCase<Product?, ViewProductParams> {
  final ProductRepository repository;

  ViewProductUsecase(this.repository);

  @override
  Future<Product?> call(ViewProductParams params) async {
    return repository.viewProduct(params.id);
  }
}