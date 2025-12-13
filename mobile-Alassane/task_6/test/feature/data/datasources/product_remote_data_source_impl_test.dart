import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

import 'package:task_6/core/error/exceptions.dart';
import 'package:task_6/core/network/api_constants.dart';
import 'package:task_6/feature/data/datasources/product_remote_data_source_impl.dart';
import 'package:task_6/feature/data/models/product_model.dart';

String fixture(String name) => File('test/fixtures/$name').readAsStringSync();

void main() {
  group('ProductRemoteDataSourceImpl', () {
    test('fetchAll -> GET /products -> returns List<ProductModel>', () async {
      final productsFixture = jsonDecode(fixture('products.json')) as Map<String, dynamic>;
      final expectedList = productsFixture['data'] as List<dynamic>;
      expect(expectedList, isA<List<dynamic>>());

      final client = MockClient((request) async {
        expect(request.method, 'GET');
        expect(
          request.url.toString(),
          '${ApiConstants.baseUrl}${ApiConstants.productsPath}',
        );

        return Response(
          fixture('products.json'),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final ds = ProductRemoteDataSourceImpl(client: client);

      final result = await ds.fetchAll();

      expect(result, isA<List<ProductModel>>());
      expect(result, isNotEmpty);

      expect(result.length, expectedList.length);

      final firstJson = expectedList.first as Map<String, dynamic>;
      expect(result.first.id, firstJson['id']);
      expect(result.first.name, firstJson['name']);
      expect(result.first.description, firstJson['description']);
      expect(result.first.imageUrl, firstJson['imageUrl']);

      expect(result.first.price, isA<num>());
    });

    test('fetchOne -> GET /products/{id} -> returns ProductModel', () async {
      const id = '6672752cbd218790438efdb0';

      final productFixture = jsonDecode(fixture('product.json')) as Map<String, dynamic>;
      final expected = productFixture['data'] as Map<String, dynamic>;

      final client = MockClient((request) async {
        expect(request.method, 'GET');
        expect(
          request.url.toString(),
          '${ApiConstants.baseUrl}${ApiConstants.productsPath}/$id',
        );

        return Response(
          fixture('product.json'),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final ds = ProductRemoteDataSourceImpl(client: client);

      final result = await ds.fetchOne(id);

      expect(result, isA<ProductModel>());
      expect(result.id, expected['id']);
      expect(result.name, expected['name']);
    });

    test('create -> POST /products with JSON body (2xx => ok)', () async {
      final product = ProductModel.fromJson(
        (jsonDecode(fixture('product.json')) as Map<String, dynamic>)['data']
            as Map<String, dynamic>,
      );

      final bodyWithId = product.toJson();
      final bodyWithoutId = Map<String, dynamic>.from(bodyWithId)..remove('id');

      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(
          request.url.toString(),
          '${ApiConstants.baseUrl}${ApiConstants.productsPath}',
        );
        expect(request.headers['Content-Type'], contains('application/json'));

        final sent = jsonDecode(request.body) as Map<String, dynamic>;

        expect(sent, anyOf(equals(bodyWithId), equals(bodyWithoutId)));

        return Response('', 201);
      });

      final ds = ProductRemoteDataSourceImpl(client: client);

      await ds.create(product);
    });

    test('update -> PUT /products/{id} with JSON body (2xx => ok)', () async {
      final product = ProductModel.fromJson(
        (jsonDecode(fixture('product.json')) as Map<String, dynamic>)['data']
            as Map<String, dynamic>,
      );

      final client = MockClient((request) async {
        expect(request.method, 'PUT');
        expect(
          request.url.toString(),
          '${ApiConstants.baseUrl}${ApiConstants.productsPath}/${product.id}',
        );
        expect(request.headers['Content-Type'], contains('application/json'));

        final sent = jsonDecode(request.body) as Map<String, dynamic>;
        expect(sent, product.toJson());

        return Response('', 200);
      });

      final ds = ProductRemoteDataSourceImpl(client: client);

      await ds.update(product);
    });

    test('delete -> DELETE /products/{id} (204 => ok)', () async {
      const id = '6672752cbd218790438efdb0';

      final client = MockClient((request) async {
        expect(request.method, 'DELETE');
        expect(
          request.url.toString(),
          '${ApiConstants.baseUrl}${ApiConstants.productsPath}/$id',
        );
        return Response('', 204);
      });

      final ds = ProductRemoteDataSourceImpl(client: client);

      await ds.delete(id);
    });

    test('throws ServerException on non-2xx', () async {
      final client = MockClient((request) async {
        return Response('boom', 500);
      });

      final ds = ProductRemoteDataSourceImpl(client: client);

      await expectLater(ds.fetchAll(), throwsA(isA<ServerException>()));
    });
  });
}