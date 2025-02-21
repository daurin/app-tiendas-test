import 'package:app_tiendas/src/app.dart';
import 'package:app_tiendas/src/domain/dtos/add_product_to_cart.dto.dart';
import 'package:app_tiendas/src/views/events/event.interface.dart';
import 'package:app_tiendas/src/views/providers/cart.provider.dart';
import 'package:provider/provider.dart';

export 'package:app_tiendas/src/domain/dtos/add_product_to_cart.dto.dart';

class AddProductToCartEvent implements Event<void, AddProductToCartDto> {
  @override
  Future<void> call(AddProductToCartDto params) async {
    final provider = navigatorContext.read<CartProvider>();
    await provider.addProductToCart(params);
  }
}