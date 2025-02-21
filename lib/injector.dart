import 'package:app_tiendas/src/Infrastructure/datasources/product_catalog.datasource.remote.dart';
import 'package:app_tiendas/src/Infrastructure/datasources/product_catalog_firebase.datasource.remote.impl.dart';
import 'package:app_tiendas/src/Infrastructure/repositories/product_catalog.repository.impl.dart';
import 'package:app_tiendas/src/domain/repositories/product_catalog.repository.dart';
import 'package:get_it/get_it.dart';

void initDependenciesInjector() {
  final getIt = GetIt.instance;

  // Registering repositories
  getIt.registerLazySingleton<ProductCatalogRepository>(
    () => ProductCatalogRepositoryImpl(getIt()),
  );

  // Data sources
  getIt.registerLazySingleton<ProductCatalogRemoteDataSource>(
    () => ProductCatalogFirebaseRemoteDataSourceImpl(),
  );
}
