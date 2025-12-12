import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:task_6/feature/data/repositories/product_repository_impl.dart';
import 'package:task_6/feature/data/datasources/product_remote_data_source.dart';
import 'package:task_6/feature/data/datasources/product_local_data_source.dart';
import 'package:task_6/core/network/network_info.dart';
import 'package:task_6/feature/domain/entities/product.dart';
import 'package:task_6/feature/data/models/product_model.dart';

@GenerateNiceMocks([
  MockSpec<ProductRemoteDataSource>(),
  MockSpec<ProductLocalDataSource>(),
  MockSpec<NetworkInfo>(),
  MockSpec<ProductModel>(),
])
import 'product_repository_impl_test.mocks.dart';

void main() {
  late ProductRepositoryImpl repository;
  late MockProductRemoteDataSource mockRemote;
  late MockProductLocalDataSource mockLocal;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemote = MockProductRemoteDataSource();
    mockLocal = MockProductLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = ProductRepositoryImpl(
      remote: mockRemote,
      local: mockLocal,
      networkInfo: mockNetworkInfo,
    );
  });

  group('viewAllProducts', () {
    test('should use remote datasource and cache when device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      final tModels = <ProductModel>[MockProductModel()];

      when(mockRemote.fetchAll()).thenAnswer((_) async => tModels);
      when(mockLocal.cacheAll(tModels)).thenAnswer((_) async {});

      final result = await repository.viewAllProducts();

      expect(result, same(tModels)); 
      verify(mockNetworkInfo.isConnected).called(1);
      verify(mockRemote.fetchAll()).called(1);
      verify(mockLocal.cacheAll(tModels)).called(1);
      verifyNever(mockLocal.getCachedAll());
      verifyNoMoreInteractions(mockRemote);
    });

    test('should use local datasource when device is offline', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final tCached = <ProductModel>[MockProductModel(), MockProductModel()];
      when(mockLocal.getCachedAll()).thenAnswer((_) async => tCached);

      // act
      final result = await repository.viewAllProducts();

      // assert
      expect(result, same(tCached));
      verify(mockNetworkInfo.isConnected).called(1);
      verify(mockLocal.getCachedAll()).called(1);
      verifyNever(mockRemote.fetchAll());
    });
  });

  group('viewProduct', () {
    const tId = '123';

    test('should use remote datasource and cache when online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      final tModel = MockProductModel();
      when(mockRemote.fetchOne(tId)).thenAnswer((_) async => tModel);
      when(mockLocal.cacheOne(tModel)).thenAnswer((_) async {});

      // act
      final result = await repository.viewProduct(tId);

      // assert
      expect(result, same(tModel));
      verify(mockNetworkInfo.isConnected).called(1);
      verify(mockRemote.fetchOne(tId)).called(1);
      verify(mockLocal.cacheOne(tModel)).called(1);
      verifyNever(mockLocal.getCachedOne(tId));
    });

    test('should use local datasource when offline and cache exists', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final tCached = MockProductModel();
      when(mockLocal.getCachedOne(tId)).thenAnswer((_) async => tCached);

      // act
      final result = await repository.viewProduct(tId);

      // assert
      expect(result, same(tCached));
      verify(mockNetworkInfo.isConnected).called(1);
      verify(mockLocal.getCachedOne(tId)).called(1);
      verifyNever(mockRemote.fetchOne(tId));
      verifyNever(mockLocal.cacheOne(any));
    });

    test('should throw Exception when offline and cache is null', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocal.getCachedOne(tId)).thenAnswer((_) async => null);

      // act + assert
      await expectLater(
        repository.viewProduct(tId),
        throwsA(
          predicate((e) =>
              e is Exception && e.toString().contains('No cached product')),
        ),
      );

      verify(mockNetworkInfo.isConnected).called(1);
      verify(mockLocal.getCachedOne(tId)).called(1);
      verifyNever(mockRemote.fetchOne(tId));
    });
  });

  group('createProduct', () {
    test('should call remote.create and local.cacheOne when online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(mockRemote.create(any)).thenAnswer((_) async {});
      when(mockLocal.cacheOne(any)).thenAnswer((_) async {});

      // IMPORTANT: adapte ceci au constructeur réel de Product chez toi
      final tProduct = Product(
        id: 'p1',
        name: 'Test',
        description: 'Desc',
        price: 10,
        imageUrl: 'https://example.com/x.png',
      );

      // act
      await repository.createProduct(tProduct);

      // assert
      verify(mockNetworkInfo.isConnected).called(1);
      verify(mockRemote.create(argThat(isA<ProductModel>()))).called(1);
      verify(mockLocal.cacheOne(argThat(isA<ProductModel>()))).called(1);
    });

    test('should throw Exception and not call remote when offline', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final tProduct = Product(
        id: 'p1',
        name: 'Test',
        description: 'Desc',
        price: 10,
        imageUrl: 'https://example.com/x.png',
      );

      // act + assert
      await expectLater(
        repository.createProduct(tProduct),
        throwsA(isA<Exception>()),
      );

      verifyNever(mockRemote.create(any));
      verifyNever(mockLocal.cacheOne(any));
    });
  });

  group('updateProduct', () {
    test('should call remote.update and local.cacheOne when online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(mockRemote.update(any)).thenAnswer((_) async {});
      when(mockLocal.cacheOne(any)).thenAnswer((_) async {});

      final tProduct = Product(
        id: 'p1',
        name: 'Updated',
        description: 'Desc',
        price: 20,
        imageUrl: 'https://example.com/y.png',
      );

      // act
      await repository.updateProduct(tProduct);

      // assert
      verify(mockNetworkInfo.isConnected).called(1);
      verify(mockRemote.update(argThat(isA<ProductModel>()))).called(1);
      verify(mockLocal.cacheOne(argThat(isA<ProductModel>()))).called(1);
    });

    test('should throw Exception and not call remote when offline', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final tProduct = Product(
        id: 'p1',
        name: 'Updated',
        description: 'Desc',
        price: 20,
        imageUrl: 'https://example.com/y.png',
      );

      // act + assert
      await expectLater(
        repository.updateProduct(tProduct),
        throwsA(isA<Exception>()),
      );

      verifyNever(mockRemote.update(any));
      verifyNever(mockLocal.cacheOne(any));
    });
  });

  group('deleteProduct', () {
    const tId = 'p1';

    test('should call remote.delete and local.removeCached when online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(mockRemote.delete(tId)).thenAnswer((_) async {});
      when(mockLocal.removeCached(tId)).thenAnswer((_) async {});

      // act
      await repository.deleteProduct(tId);

      // assert
      verify(mockNetworkInfo.isConnected).called(1);
      verify(mockRemote.delete(tId)).called(1);
      verify(mockLocal.removeCached(tId)).called(1);
    });

    test('should throw Exception and not call remote when offline', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // act + assert
      await expectLater(
        repository.deleteProduct(tId),
        throwsA(isA<Exception>()),
      );

      verifyNever(mockRemote.delete(any));
      verifyNever(mockLocal.removeCached(any));
    });
  });
}