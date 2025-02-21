import 'package:app_tiendas/src/domain/dtos/add_product_to_cart.dto.dart';
import 'package:app_tiendas/src/domain/dtos/get_product_cart.dto.dart';
import 'package:app_tiendas/src/domain/entities/product.entity.dart';

abstract class ProductCatalogRemoteDataSource {
  Future<List<ProductEntity>> getProducts();
  Future<GetCartDto?> getCart();
  Future<void> addProductToCart(AddProductToCartDto params);
  Future<void> removeProductFromCart(String productId);
  Future<void> clearCart();
}