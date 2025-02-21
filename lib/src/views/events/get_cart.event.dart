import 'package:app_tiendas/src/app.dart';
import 'package:app_tiendas/src/domain/dtos/get_product_cart.dto.dart';
import 'package:app_tiendas/src/views/events/event.interface.dart';
import 'package:app_tiendas/src/views/blocs/cart.bloc.dart';
import 'package:provider/provider.dart';

export 'package:app_tiendas/src/views/events/event.interface.dart';

class GetCartEvent implements Event<GetCartDto?, NoParams> {
  @override
  Future<GetCartDto?> call(NoParams params) {
    final bloc = navigatorContext.read<CartBloc>();
    return bloc.getCart();
  }
}