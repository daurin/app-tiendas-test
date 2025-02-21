import 'package:app_tiendas/src/app.dart';
import 'package:app_tiendas/src/domain/dtos/add_product_to_cart.dto.dart';
import 'package:app_tiendas/src/views/events/event.interface.dart';
import 'package:app_tiendas/src/views/blocs/cart.bloc.dart';
import 'package:provider/provider.dart';

export 'package:app_tiendas/src/domain/dtos/add_product_to_cart.dto.dart';

class AddProductToCartEvent implements Event<void, AddProductToCartDto> {
  @override
  Future<void> call(AddProductToCartDto params) async {
    final bloc = navigatorContext.read<CartBloc>();
    await bloc.addProductToCart(params);
  }
}