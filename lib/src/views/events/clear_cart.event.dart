import 'package:app_tiendas/src/app.dart';
import 'package:app_tiendas/src/views/events/event.interface.dart';
import 'package:app_tiendas/src/views/blocs/cart.bloc.dart';
import 'package:provider/provider.dart';

export 'package:app_tiendas/src/views/events/event.interface.dart';

class ClearCartEvent implements Event<void, NoParams> {
  @override
  Future<void> call(NoParams params) async {
    final bloc = navigatorContext.read<CartBloc>();
    await bloc.claerCart();
  }
}