import '../../../core/network/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart';
import '../../../core/error/exceptions.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remote;
  final ProductLocalDataSource local;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remote,
    required this.local,
    required this.networkInfo,
  });

  @override
  Future<List<Product>> viewAllProducts() async {
    if (await networkInfo.isConnected) {
      final models = await remote.fetchAll();          
      await local.cacheAll(models);
      return models;                                  
    } else {
      final cached = await local.getCachedAll();       
      return cached;                                   
    }
  }

  @override
  Future<Product> viewProduct(String id) async {
    if (await networkInfo.isConnected) {
      final model = await remote.fetchOne(id);        
      await local.cacheOne(model);
      return model;                                    
    } else {
      final cached = await local.getCachedOne(id);     
      if (cached == null) {
        throw CacheMissException('No cached product for id=$id');
      }
      return cached;                                  
    }
  }

  @override
  Future<void> createProduct(Product product) async {
    final model = ProductModel.fromEntity(product);
    if (await networkInfo.isConnected) {
      await remote.create(model);
      await local.cacheOne(model);
    } else {
      throw NoInternetConnectionException('cannot create product');
    }
  }

  @override
  Future<void> updateProduct(Product product) async {
    final model = ProductModel.fromEntity(product);
    if (await networkInfo.isConnected) {
      await remote.update(model);
      await local.cacheOne(model);
    } else {
      throw NoInternetConnectionException('cannot update product');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    if (await networkInfo.isConnected) {
      await remote.delete(id);
      await local.removeCached(id);
    } else {
      throw NoInternetConnectionException('cannot delete product');
    }
  }
}