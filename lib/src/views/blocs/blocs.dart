import 'package:app_tiendas/src/views/blocs/cart.bloc.dart';
import 'package:app_tiendas/src/views/blocs/product_catalog.bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final List<SingleChildWidget> blocs = [
  ChangeNotifierProvider<ProductCatalogBloc>(create: (_) => ProductCatalogBloc()),
  ChangeNotifierProvider<CartBloc>(create: (_) => CartBloc()),
];
