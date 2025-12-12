class Product {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final String category;
  final double rating;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.category = '',
    this.rating = 0.0,
  });

  String get title => name;

  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    double? price,
    String? category,
    double? rating,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      category: category ?? this.category,
      rating: rating ?? this.rating,
    );
  }
}