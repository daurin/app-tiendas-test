import 'package:app_tiendas/src/app.dart';
import 'package:app_tiendas/src/views/events/add_product_to_cart.event.dart';
import 'package:app_tiendas/src/views/events/remove_product_from_cart.event.dart';
import 'package:app_tiendas/src/views/pages/product_details/product_details.page.dart';
import 'package:flutter/material.dart';

mixin ProductCatalogFragmentController {
  void initStateController() {
    fetchProducts();
  }

  void disposeController() {

  }

  void fetchProducts() async {
    
  }

  void onTapProduct(String id) {
    Navigator.push(
      navigatorContext,
      MaterialPageRoute(
      builder: (context) => ProductDetailsPage(productId: id),
      ),
    );
  }

  void addProductToCart(String productId) {
    AddProductToCartEvent().call(AddProductToCartDto(productId: productId));
  }

  void onTapRemoveFromCart(String productId) {
    RemoveProductFromCartEvent().call(productId);
  }
}