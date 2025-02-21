import 'package:app_tiendas/src/app.dart';
import 'package:app_tiendas/src/domain/repositories/product_catalog.repository.dart';
import 'package:app_tiendas/src/views/events/event.interface.dart';
import 'package:app_tiendas/src/views/providers/product_catalog.provider.dart';
import 'package:provider/provider.dart';

export 'package:app_tiendas/src/views/events/event.interface.dart';

class GetProductsEvent implements Event<List<ProductEntity>, NoParams> {
  @override
  Future<List<ProductEntity>> call(NoParams params) {
    final provider = navigatorContext.read<ProductCatalogProvider>();
    return provider.getProducts();
  }
}