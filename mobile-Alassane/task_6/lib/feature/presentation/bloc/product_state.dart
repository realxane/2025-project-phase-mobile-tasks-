import 'package:equatable/equatable.dart';
import 'package:task_6/feature/domain/entities/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class EmptyState extends ProductState {
  const EmptyState();
}

class IntialState extends EmptyState {
  const IntialState();
}

class LoadingState extends ProductState {
  const LoadingState();
}

class LoadedAllProductState extends ProductState {
  final List<Product> products;
  const LoadedAllProductState(this.products);

  @override
  List<Object?> get props => [products];
}

class LoadedSingleProductState extends ProductState {
  final Product product;
  const LoadedSingleProductState(this.product);

  @override
  List<Object?> get props => [product];
}

class ErrorState extends ProductState {
  final String message;
  const ErrorState(this.message);

  @override
  List<Object?> get props => [message];
}