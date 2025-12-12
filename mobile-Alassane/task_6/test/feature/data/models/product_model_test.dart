import 'package:flutter_test/flutter_test.dart';
import 'package:task_6/feature/data/models/product_model.dart';
import 'package:task_6/feature/domain/entities/product.dart';

void main() {
  const tModel = ProductModel(
    id: '1',
    name: 'iPhone',
    description: 'A smartphone',
    imageUrl: 'https://example.com/iphone.png',
    price: 999.99,
    category: 'Electronics',
    rating: 4.7,
  );

  group('ProductModel', () {
    test('should be a subclass of Product entity', () {
      expect(tModel, isA<Product>());
    });

    test('fromJson should return a valid ProductModel when all fields are present', () {
      final jsonMap = {
        'id': '1',
        'name': 'iPhone',
        'description': 'A smartphone',
        'imageUrl': 'https://example.com/iphone.png',
        'price': 999.99,
        'category': 'Electronics',
        'rating': 4.7,
      };

      final result = ProductModel.fromJson(jsonMap);

      expect(result.id, tModel.id);
      expect(result.name, tModel.name);
      expect(result.description, tModel.description);
      expect(result.imageUrl, tModel.imageUrl);
      expect(result.price, tModel.price);
      expect(result.category, tModel.category);
      expect(result.rating, tModel.rating);
    });

    test('fromJson should use default values when optional fields are missing', () {
      final jsonMap = {
        'id': '2',
        'name': 'Book',
        'description': 'A nice book',
        'imageUrl': 'https://example.com/book.png',
        'price': 12, // int -> double
        // category missing -> default ''
        // rating missing -> default 0.0
      };

      final result = ProductModel.fromJson(jsonMap);

      expect(result.id, '2');
      expect(result.name, 'Book');
      expect(result.description, 'A nice book');
      expect(result.imageUrl, 'https://example.com/book.png');
      expect(result.price, 12.0);
      expect(result.category, '');
      expect(result.rating, 0.0);
    });

    test('toJson should return a JSON map containing proper data', () {
      final result = tModel.toJson();

      expect(result, {
        'id': '1',
        'name': 'iPhone',
        'description': 'A smartphone',
        'imageUrl': 'https://example.com/iphone.png',
        'price': 999.99,
        'category': 'Electronics',
        'rating': 4.7,
      });
    });

    test('fromJson -> toJson should round-trip consistently', () {
      final jsonMap = {
        'id': '3',
        'name': 'TV',
        'description': '4K TV',
        'imageUrl': 'https://example.com/tv.png',
        'price': '499.50', // string -> double (robuste)
        'category': 'Electronics',
        'rating': 4, // int -> double
      };

      final model = ProductModel.fromJson(jsonMap);
      final backToJson = model.toJson();

      expect(backToJson['id'], '3');
      expect(backToJson['price'], 499.5);
      expect(backToJson['rating'], 4.0);
    });
  });
}