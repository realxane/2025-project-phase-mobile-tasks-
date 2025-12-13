import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_6/core/error/exceptions.dart';
import 'package:task_6/feature/data/datasources/product_local_data_Source_impl.dart';
import 'package:task_6/feature/data/models/product_model.dart';

import 'product_local_data_source_impl_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late MockSharedPreferences mockSharedPreferences;
  late ProductLocalDatasourceImpl datasource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    datasource = ProductLocalDatasourceImpl(sharedPreferences: mockSharedPreferences);
  });

  List<ProductModel> tProducts() => const [
        ProductModel(
          id: '1',
          name: 'Nike Air',
          category: 'Shoes',
          price: 120,
          rating: 4.5,
          imageUrl: 'https://example.com/1.png',
          description: 'Nice shoes',
        ),
        ProductModel(
          id: '2',
          name: 'Adidas Run',
          category: 'Shoes',
          price: 90,
          rating: 4.2,
          imageUrl: 'https://example.com/2.png',
          description: 'Running shoes',
        ),
      ];

  String encodeProducts(List<ProductModel> products) =>
      jsonEncode(products.map((e) => e.toJson()).toList());

  group('cacheAll', () {
    test('should call SharedPreferences.setString with encoded JSON', () async {
      // arrange
      final products = tProducts();
      final expectedJson = encodeProducts(products);
      when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);

      // act
      await datasource.cacheAll(products);

      // assert
      verify(mockSharedPreferences.setString(
        ProductLocalDatasourceImpl.cachedProductsKey,
        expectedJson,
      ));
      verifyNoMoreInteractions(mockSharedPreferences);
    });

    test('should throw CacheException when setString returns false', () async {
      // arrange
      when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => false);

      // act
      final call = datasource.cacheAll(tProducts());

      // assert
      await expectLater(call, throwsA(isA<CacheException>()));
    });
  });

  group('getCachedAll', () {
    test('should return cached products when cache exists', () async {
      // arrange
      final products = tProducts();
      final cachedJson = encodeProducts(products);
      when(mockSharedPreferences.getString(any)).thenReturn(cachedJson);

      // act
      final result = await datasource.getCachedAll();

      // assert (compare via JSON to avoid == issues)
      expect(
        result.map((e) => e.toJson()).toList(),
        equals(products.map((e) => e.toJson()).toList()),
      );
      verify(mockSharedPreferences.getString(ProductLocalDatasourceImpl.cachedProductsKey));
      verifyNoMoreInteractions(mockSharedPreferences);
    });

    test('should throw CacheException when there is no cached value', () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      // act
      final call = datasource.getCachedAll();

      // assert
      await expectLater(call, throwsA(isA<CacheException>()));
    });
  });

  group('getCachedOne', () {
    test('should return one product when found', () async {
      // arrange
      final products = tProducts();
      when(mockSharedPreferences.getString(any)).thenReturn(encodeProducts(products));

      // act
      final result = await datasource.getCachedOne('2');

      // assert
      expect(result?.id, '2');
      verify(mockSharedPreferences.getString(ProductLocalDatasourceImpl.cachedProductsKey));
      verifyNoMoreInteractions(mockSharedPreferences);
    });

    test('should return null when not found', () async {
      // arrange
      final products = tProducts();
      when(mockSharedPreferences.getString(any)).thenReturn(encodeProducts(products));

      // act
      final result = await datasource.getCachedOne('999');

      // assert
      expect(result, isNull);
      verify(mockSharedPreferences.getString(ProductLocalDatasourceImpl.cachedProductsKey));
      verifyNoMoreInteractions(mockSharedPreferences);
    });
  });

  group('cacheOne', () {
    test('should create cache list when none exists', () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);

      final product = tProducts().first;
      final expectedJson = encodeProducts([product]);

      // act
      await datasource.cacheOne(product);

      // assert
      verify(mockSharedPreferences.getString(ProductLocalDatasourceImpl.cachedProductsKey));
      verify(mockSharedPreferences.setString(
        ProductLocalDatasourceImpl.cachedProductsKey,
        expectedJson,
      ));
      verifyNoMoreInteractions(mockSharedPreferences);
    });

    test('should update existing product with same id', () async {
      // arrange
      final products = tProducts();
      when(mockSharedPreferences.getString(any)).thenReturn(encodeProducts(products));
      when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);

      final updated = ProductModel(
        id: '2',
        name: 'Adidas Run V2',
        category: 'Shoes',
        price: 95,
        rating: 4.3,
        imageUrl: 'https://example.com/2b.png',
        description: 'Updated',
      );

      final expectedList = [
        products[0],
        updated,
      ];
      final expectedJson = encodeProducts(expectedList);

      // act
      await datasource.cacheOne(updated);

      // assert
      verify(mockSharedPreferences.getString(ProductLocalDatasourceImpl.cachedProductsKey));
      verify(mockSharedPreferences.setString(
        ProductLocalDatasourceImpl.cachedProductsKey,
        expectedJson,
      ));
      verifyNoMoreInteractions(mockSharedPreferences);
    });
  });

  group('removeCached', () {
    test('should remove product by id and persist updated list', () async {
      // arrange
      final products = tProducts();
      when(mockSharedPreferences.getString(any)).thenReturn(encodeProducts(products));
      when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);

      final expectedList = [products[1]]; // remove id '1'
      final expectedJson = encodeProducts(expectedList);

      // act
      await datasource.removeCached('1');

      // assert
      verify(mockSharedPreferences.getString(ProductLocalDatasourceImpl.cachedProductsKey));
      verify(mockSharedPreferences.setString(
        ProductLocalDatasourceImpl.cachedProductsKey,
        expectedJson,
      ));
      verifyNoMoreInteractions(mockSharedPreferences);
    });

    test('should throw CacheException if no cache exists', () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      // act
      final call = datasource.removeCached('1');

      // assert
      await expectLater(call, throwsA(isA<CacheException>()));
    });
  });
}