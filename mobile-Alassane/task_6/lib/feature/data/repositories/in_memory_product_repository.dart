import 'package:task_6/feature/domain/entities/product.dart';
import 'package:task_6/feature/domain/product_repository.dart';

class InMemoryProductRepository implements ProductRepository {
  InMemoryProductRepository._internal()
      : _products = List.generate(
          6,
          (i) => Product(
            id: '$i',
            name: 'Derby Leather Shoes',
            category: "Men's shoe",
            price: 120.0, // double
            rating: 4.0,
            imageUrl:
                'https://www.oliversweeney.com/cdn/shop/files/Eastington_Cognac_1_sq1_9b3a983e-f624-47a1-ab17-bb58e32ebd40_630x806.progressive.jpg?v=1691063210',
            description: 'Classic derby leather shoes, item #\$i',
          ),
        );

  static final InMemoryProductRepository _instance =
      InMemoryProductRepository._internal();

  factory InMemoryProductRepository() => _instance;

  final List<Product> _products;

  @override
  Future<List<Product>> viewAllProducts() async {
    return List.unmodifiable(_products);
  }

  @override
  Future<Product> viewProduct(String id) async {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      throw Exception('Product not found for id=$id');
    }
  }

  @override
  Future<void> createProduct(Product product) async {
    _products.add(product);
  }

  @override
  Future<void> updateProduct(Product product) async {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    _products.removeWhere((p) => p.id == id);
  }
}