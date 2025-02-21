import 'package:app_tiendas/src/app.dart';
import 'package:app_tiendas/src/views/events/add_product_to_cart.event.dart';
import 'package:app_tiendas/src/views/events/remove_product_from_cart.event.dart';
import 'package:app_tiendas/src/views/fragments/cart/cart.fragment.dart';
import 'package:flutter/material.dart';

mixin ProductDetailsPageController {
  ValueNotifier<int> cartQuantityNotifier = ValueNotifier<int>(1);

  String _productId = '';

  void initStateController(String productId) {
    _productId = productId;
    fetchProduct();
  }

  void disposeController() {
    cartQuantityNotifier.dispose();
  }

  void fetchProduct() async {}

  void incrementCartQuantity() {
    cartQuantityNotifier.value++;
  }

  void decrementCartQuantity() {
    cartQuantityNotifier.value--;
  }

  void addToCart() {
    AddProductToCartEvent().call(AddProductToCartDto(
      productId: _productId,
      quantity: cartQuantityNotifier.value,
    ));
  }

  void removeFromCart() {
    RemoveProductFromCartEvent().call(_productId);
  }

  void onTapCart() {
    Navigator.push(
      navigatorContext,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Carrito'),
          ),
          body: CartFragment(),
        ),
      ),
    );
  }
}
