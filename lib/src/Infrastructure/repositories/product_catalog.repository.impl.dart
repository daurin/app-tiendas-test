import 'package:app_tiendas/src/Infrastructure/datasources/product_catalog.datasource.remote.dart';
import 'package:app_tiendas/src/domain/dtos/add_product_to_cart.dto.dart';
import 'package:app_tiendas/src/domain/dtos/get_product_cart.dto.dart';
import 'package:app_tiendas/src/domain/repositories/product_catalog.repository.dart';
import 'package:app_tiendas/src/views/events/add_product_to_cart.event.dart';

class ProductCatalogRepositoryImpl implements ProductCatalogRepository {

  final ProductCatalogRemoteDataSource remoteDatasource;

  ProductCatalogRepositoryImpl(this.remoteDatasource);

  

  @override
  Future<void> addProductToCart(AddProductToCartDto params) {
    return remoteDatasource.addProductToCart(params);
  }

  @override
  Future<void> clearCart() {
    return remoteDatasource.clearCart();
  }

  @override
  Future<GetCartDto?> getCart() {
    return remoteDatasource.getCart();
  }

  @override
  Future<List<ProductEntity>> getProducts() {
    return remoteDatasource.getProducts();
  }

  @override
  Future<void> removeProductFromCart(String productId) {
    return remoteDatasource.removeProductFromCart(productId);
  }

}