import 'package:bloc/bloc.dart';
import 'package:task_6/core/error/exceptions.dart';
import 'package:task_6/core/usecase/usecase.dart';
import 'package:task_6/feature/domain/entities/product.dart';
import 'package:task_6/feature/domain/usecases/create_product_usecase.dart';
import 'package:task_6/feature/domain/usecases/delete_product_usecase.dart';
import 'package:task_6/feature/domain/usecases/update_product_usecase.dart';
import 'package:task_6/feature/domain/usecases/view_all_products_usecase.dart';
import 'package:task_6/feature/domain/usecases/view_product_usecase.dart';

import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ViewAllProductsUseCase viewAllProductsUseCase;
  final ViewProductUseCase viewProductUseCase;
  final CreateProductUseCase createProductUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;

  ProductBloc({
    required this.viewAllProductsUseCase,
    required this.viewProductUseCase,
    required this.createProductUseCase,
    required this.updateProductUseCase,
    required this.deleteProductUseCase,
  }) : super(const IntialState()) {
    on<LoadAllProductEvent>(_onLoadAll);
    on<GetSingleProductEvent>(_onGetSingle);
    on<CreateProductEvent>(_onCreate);
    on<UpdateProductEvent>(_onUpdate);
    on<DeleteProductEvent>(_onDelete);
  }

  Future<void> _onLoadAll(
    LoadAllProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const LoadingState());
    try {
      final List<Product> products = await viewAllProductsUseCase(NoParams());
      emit(LoadedAllProductState(products));
    } catch (e) {
      emit(ErrorState(_mapExceptionToMessage(e)));
    }
  }

  Future<void> _onGetSingle(
    GetSingleProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const LoadingState());
    try {
      final Product? product =
          await viewProductUseCase(ViewProductParams(event.id));

      if (product == null) {
        emit(const ErrorState('Product not found.'));
        return;
      }

      emit(LoadedSingleProductState(product));
    } catch (e) {
      emit(ErrorState(_mapExceptionToMessage(e)));
    }
  }

  Future<void> _onCreate(
    CreateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const LoadingState());
    try {
      await createProductUseCase(event.product);
      emit(LoadedSingleProductState(event.product));
    } catch (e) {
      emit(ErrorState(_mapExceptionToMessage(e)));
    }
  }

  Future<void> _onUpdate(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const LoadingState());
    try {
      await updateProductUseCase(event.product);
      emit(LoadedSingleProductState(event.product));
    } catch (e) {
      emit(ErrorState(_mapExceptionToMessage(e)));
    }
  }

  Future<void> _onDelete(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const LoadingState());
    try {
      await deleteProductUseCase(DeleteProductParams(event.id));

      final products = await viewAllProductsUseCase(NoParams());
      emit(LoadedAllProductState(products));
    } catch (e) {
      emit(ErrorState(_mapExceptionToMessage(e)));
    }
  }

  String _mapExceptionToMessage(Object exception) {
    if (exception is ServerException) {
      return 'Server error occurred.';
    } else if (exception is CacheException) {
      return 'Cache error occurred.';
    } else {
      return 'An unexpected error occurred.';
    }
  }
}