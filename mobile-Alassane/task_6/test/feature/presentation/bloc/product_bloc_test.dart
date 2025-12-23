import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:task_6/core/error/exceptions.dart';
import 'package:task_6/core/usecase/usecase.dart';
import 'package:task_6/feature/domain/entities/product.dart';
import 'package:task_6/feature/domain/usecases/create_product_usecase.dart';
import 'package:task_6/feature/domain/usecases/delete_product_usecase.dart';
import 'package:task_6/feature/domain/usecases/update_product_usecase.dart';
import 'package:task_6/feature/domain/usecases/view_all_products_usecase.dart';
import 'package:task_6/feature/domain/usecases/view_product_usecase.dart';
import 'package:task_6/feature/presentation/bloc/product_bloc.dart';
import 'package:task_6/feature/presentation/bloc/product_event.dart';
import 'package:task_6/feature/presentation/bloc/product_state.dart';

import 'product_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ViewAllProductsUseCase>(),
  MockSpec<ViewProductUseCase>(),
  MockSpec<CreateProductUseCase>(),
  MockSpec<UpdateProductUseCase>(),
  MockSpec<DeleteProductUseCase>(),
])
void main() {
  late MockViewAllProductsUseCase mockViewAll;
  late MockViewProductUseCase mockViewOne;
  late MockCreateProductUseCase mockCreate;
  late MockUpdateProductUseCase mockUpdate;
  late MockDeleteProductUseCase mockDelete;

  const tProduct = Product(
    id: '1',
    name: 'Phone',
    description: 'Test',
    price: 999.0,
    imageUrl: 'x',
  );

  final tProducts = [tProduct];

  ProductBloc buildBloc() => ProductBloc(
        viewAllProductsUseCase: mockViewAll,
        viewProductUseCase: mockViewOne,
        createProductUseCase: mockCreate,
        updateProductUseCase: mockUpdate,
        deleteProductUseCase: mockDelete,
      );

  setUp(() {
    mockViewAll = MockViewAllProductsUseCase();
    mockViewOne = MockViewProductUseCase();
    mockCreate = MockCreateProductUseCase();
    mockUpdate = MockUpdateProductUseCase();
    mockDelete = MockDeleteProductUseCase();
  });

  test('initial state', () async {
    final bloc = buildBloc();
    expect(bloc.state, isA<IntialState>()); 
    await bloc.close();
  });

  blocTest<ProductBloc, ProductState>(
    'LoadAllProductEvent -> LoadingState ثم LoadedAllProductState (success)',
    build: () {
      when(mockViewAll.call(any)).thenAnswer((_) async => tProducts);
      return buildBloc();
    },
    act: (b) => b.add(const LoadAllProductEvent()),
    expect: () => [
      isA<LoadingState>(),
      isA<LoadedAllProductState>(),
    ],
  );

  blocTest<ProductBloc, ProductState>(
    'LoadAllProductEvent -> [LoadingState, LoadedAllProductState] (success)',
    build: () {
      when(mockViewAll.call(any)).thenAnswer((_) async => throw ServerException(statusCode: 500, body: 'Server Error'));
      return buildBloc();
    },
    act: (b) => b.add(const LoadAllProductEvent()),
    expect: () => [
      isA<LoadingState>(),
      isA<ErrorState>(),
    ],
  );

  blocTest<ProductBloc, ProductState>(
    'GetSingleProductEvent -> LoadingState ثم LoadedSingleProductState (success)',
    build: () {
      when(mockViewOne.call(any)).thenAnswer((_) async => tProduct);
      return buildBloc();
    },
    act: (b) => b.add(const GetSingleProductEvent('1')),
    expect: () => [
      isA<LoadingState>(),
      isA<LoadedSingleProductState>(),
    ],
  );

  blocTest<ProductBloc, ProductState>(
    'CreateProductEvent -> LoadingState ثم LoadedSingleProductState (success)',
    build: () {
      when(mockCreate.call(any)).thenAnswer((_) async {});
      return buildBloc();
    },
    act: (b) => b.add(const CreateProductEvent(tProduct)),
    expect: () => [
      isA<LoadingState>(),
      isA<LoadedSingleProductState>(),
    ],
  );

  blocTest<ProductBloc, ProductState>(
    'DeleteProductEvent -> LoadingState ثم LoadedAllProductState',
    build: () {
      when(mockDelete.call(any)).thenAnswer((_) async {});
      when(mockViewAll.call(any)).thenAnswer((_) async => tProducts);
      return buildBloc();
    },
    act: (b) => b.add(const DeleteProductEvent('1')),
    expect: () => [
      isA<LoadingState>(),
      isA<LoadedAllProductState>(),
    ],
  );
}