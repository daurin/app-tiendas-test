// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app_tiendas/src/domain/entities/cart_product.entity.dart';
import 'package:app_tiendas/src/domain/repositories/product_catalog.repository.dart';

class GetCartDto {
  List<ProductEntity> products;
  List<CartProductEntity> cartProducts;
  double total;
  
  GetCartDto({
    required this.products,
    required this.cartProducts,
    required this.total,
  });

  GetCartDto copyWith({
    List<ProductEntity>? products,
    List<CartProductEntity>? cartProducts,
    double? total,
  }) {
    return GetCartDto(
      products: products ?? this.products,
      cartProducts: cartProducts ?? this.cartProducts,
      total: total ?? this.total,
    );
  }
}
