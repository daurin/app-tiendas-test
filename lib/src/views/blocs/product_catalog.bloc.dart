import 'package:app_tiendas/src/domain/repositories/product_catalog.repository.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ProductCatalogBloc extends ChangeNotifier {
  bool isLoading = true;
  List<ProductEntity> products = [];

  Future<List<ProductEntity>> getProducts() async {
    if(!isLoading) {
      isLoading = true;
      notifyListeners();
    }
    products = await GetIt.instance<ProductCatalogRepository>().getProducts();
    isLoading = false;
    notifyListeners();
    return products;
  }

  ProductEntity? getProductById(String id) {
    try {
      return products.firstWhere((element) => element.id == id);
    } catch (e) {
      return null;
    }
  }
}
