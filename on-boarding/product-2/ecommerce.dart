class Product {
  String _name;
  String _description;
  double _price;
  bool _isCompleted;
  Product({
    required String name,
    required String description,
    required double price,
    bool isCompleted = false,
  })  : _name = name,
        _description = description,
        _price = price,
        _isCompleted = isCompleted;

  // Getters
  String get name => _name;
  String get description => _description;
  double get price => _price;
  bool get isCompleted => _isCompleted;

  // Setters
  set name(String newName) => _name = newName;
  set description(String newDescription) => _description = newDescription;
  set price(double newPrice) => _price = newPrice;
  set isCompleted(bool status) => _isCompleted = status;

  @override
  String toString() {
    return "Product(name: ${_name}, description: ${_description}, price: ${_price})\n";
  }
}

class ProductManager{
  final List<Product> _products=[];

  //Add a new product
  void addProduct(Product p){
    _products.add(p);
  }

  //View all products
  void viewAllProducts(){
    if (_products.isEmpty) print("No product!");
    else {
      for(Product p in _products) print(p.toString());
    }

  }

  //View a single product
  Product? viewProduct(String name){
    try{
      return _products.firstWhere(
        (p)=> p._name.toLowerCase()==name.toLowerCase()
      );
    } catch(e){
      print("Product not found!");
      return null;
    }
  }

  //Edit a product (update name, description, price)
  void editProduct(String name, 
            {String? neWname, String? neWdescription, double? neWprice}){
    var product = viewProduct(name);
    if (product != null){
      if (neWname!=null) product._name=neWname;
      if (neWdescription!=null) product._description=neWdescription;
      if (neWprice!=null) product._price=neWprice;
      print("Product ${name} updated!");
    }
  }

  //Delete a product
  void deleteProduct(String name){
    _products.removeWhere(
      (p)=> p._name.toLowerCase()==name.toLowerCase()
    );
    print("Product ${name} deleted! \n");
  }

  //view completed
  List<Product> viewCompleted() {
    return _products.where((p) => p._isCompleted).toList();
  }

  //view pending
  List<Product> viewPending() {
  return _products.where((p) => !p._isCompleted).toList();
}

}