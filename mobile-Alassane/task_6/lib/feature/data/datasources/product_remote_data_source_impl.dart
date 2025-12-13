import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_constants.dart';
import '../models/product_model.dart';
import 'product_remote_data_source.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl({required this.client});

  static const _jsonHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  bool _isSuccess(int code) => code >= 200 && code < 300;

  Uri _productsUri([String? id]) {
    final base = '${ApiConstants.baseUrl}${ApiConstants.productsPath}';
    return Uri.parse(id == null ? base : '$base/$id');
  }

  /// allow to suppport responses with types:
  /// - [ {...}, {...} ]
  /// - { "data": [ {...} ] }
  /// - { "data": {...} }
  dynamic _unwrapData(dynamic decoded) {
    if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
      return decoded['data'];
    }
    return decoded;
  }

  @override
  Future<List<ProductModel>> fetchAll() async {
    final response = await client.get(
      _productsUri(),
      headers: const {'Accept': 'application/json'},
    );

    if (!_isSuccess(response.statusCode)) {
      throw ServerException(statusCode: response.statusCode, body: response.body);
    }

    final decoded = jsonDecode(response.body);
    final data = _unwrapData(decoded);

    if (data is! List) {
      throw const FormatException('Expected a JSON list for products.');
    }

    return data
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ProductModel> fetchOne(String id) async {
    final response = await client.get(
      _productsUri(id),
      headers: const {'Accept': 'application/json'},
    );

    if (!_isSuccess(response.statusCode)) {
      throw ServerException(statusCode: response.statusCode, body: response.body);
    }

    final decoded = jsonDecode(response.body);
    final data = _unwrapData(decoded);

    if (data is! Map<String, dynamic>) {
      throw const FormatException('Expected a JSON object for product.');
    }

    return ProductModel.fromJson(data);
  }

  @override
  Future<void> create(ProductModel product) async {
    final response = await client.post(
      _productsUri(),
      headers: _jsonHeaders,
      body: jsonEncode(product.toJson()),
    );

    if (!_isSuccess(response.statusCode)) {
      throw ServerException(statusCode: response.statusCode, body: response.body);
    }
  }

  @override
  Future<void> update(ProductModel product) async {
    final id = product.id; 
    if (id == null || (id is String && id.isEmpty)) {
      throw ArgumentError('Product id is required for update()');
    }

    final response = await client.put(
      _productsUri(id.toString()),
      headers: _jsonHeaders,
      body: jsonEncode(product.toJson()),
    );

    if (!_isSuccess(response.statusCode)) {
      throw ServerException(statusCode: response.statusCode, body: response.body);
    }
  }

  @override
  Future<void> delete(String id) async {
    final response = await client.delete(
      _productsUri(id),
      headers: const {'Accept': 'application/json'},
    );

    if (!_isSuccess(response.statusCode)) {
      throw ServerException(statusCode: response.statusCode, body: response.body);
    }
  }
}