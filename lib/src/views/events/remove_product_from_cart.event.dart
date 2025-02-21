import 'package:app_tiendas/src/app.dart';
import 'package:app_tiendas/src/views/events/event.interface.dart';
import 'package:app_tiendas/src/views/blocs/cart.bloc.dart';
import 'package:provider/provider.dart';

export 'package:app_tiendas/src/domain/dtos/add_product_to_cart.dto.dart';

class RemoveProductFromCartEvent implements Event<void, String> {
  @override
  Future<void> call(String productId) async {
    final bloc = navigatorContext.read<CartBloc>();
    await bloc.removeProductFromCart(productId);
  }
}