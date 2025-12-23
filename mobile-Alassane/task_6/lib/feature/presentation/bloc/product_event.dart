import 'package:equatable/equatable.dart';
import 'package:task_6/feature/domain/entities/product.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllProductEvent extends ProductEvent {
  const LoadAllProductEvent();
}

class GetSingleProductEvent extends ProductEvent {
  final String id;
  const GetSingleProductEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateProductEvent extends ProductEvent {
  final Product product;
  const UpdateProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}

class DeleteProductEvent extends ProductEvent {
  final String id;
  const DeleteProductEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateProductEvent extends ProductEvent {
  final Product product;
  const CreateProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}