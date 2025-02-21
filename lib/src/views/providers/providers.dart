import 'package:app_tiendas/src/views/providers/cart.provider.dart';
import 'package:app_tiendas/src/views/providers/product_catalog.provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final List<SingleChildWidget> providers = [
  ChangeNotifierProvider<ProductCatalogProvider>(create: (_) => ProductCatalogProvider()),
  ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
];
