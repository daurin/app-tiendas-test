import 'package:app_tiendas/src/app.dart';
import 'package:app_tiendas/src/views/events/add_product_to_cart.event.dart';
import 'package:app_tiendas/src/views/events/clear_cart.event.dart';
import 'package:app_tiendas/src/views/events/remove_product_from_cart.event.dart';
import 'package:app_tiendas/src/views/providers/cart.provider.dart';
import 'package:app_tiendas/utils/debounce.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

mixin CartFragmentController {
  ValueNotifier<Map<String, int>> cartQuantityNotifier =
      ValueNotifier<Map<String, int>>({});

  final Debounce _debounceAddProductToCart =
      Debounce(delay: Duration(milliseconds: 600));

  void initStateController() {
    
    cartProviderListener();
    navigatorContext.read<CartProvider>().addListener(cartProviderListener);
  }

  void disposeController() {
    navigatorContext.read<CartProvider>().removeListener(cartProviderListener);
  }

  void cartProviderListener() {
    CartProvider provider = navigatorContext.read<CartProvider>();
    if (provider.isLoading) return;
    if (provider.cart == null) return;

    cartQuantityNotifier.value = provider.cart!.cartProducts
        .fold<Map<String, int>>({}, (previousValue, element) {
      previousValue[element.productId] = element.quantity;
      return previousValue;
    });
  }

  void onTapIncraseQuantityCart(String productId) {
    Map<String, int> cartQuantity = Map.from(cartQuantityNotifier.value);

    if (cartQuantity[productId] == null) return;

    cartQuantity[productId] = cartQuantity[productId]! + 1;
    cartQuantityNotifier.value = cartQuantity;

    _debounceAddProductToCart.run(() {
      AddProductToCartEvent().call(AddProductToCartDto(
        productId: productId,
        quantity: cartQuantity[productId]!,
      ));
    });
  }

  void onTapDecreaseQuantityCart(String productId) {
    Map<String, int> cartQuantity = Map.from(cartQuantityNotifier.value);

    if (cartQuantity[productId] == null) return;

    cartQuantity[productId] = cartQuantity[productId]! - 1;
    cartQuantityNotifier.value = cartQuantity;

    _debounceAddProductToCart.run(() {
      AddProductToCartEvent().call(AddProductToCartDto(
        productId: productId,
        quantity: cartQuantity[productId]!,
      ));
    });
  }

  void onTapRemoveFromCart(String productId) {
    RemoveProductFromCartEvent().call(productId);
  }

  void onTapClearCart() {
    ClearCartEvent().call(NoParams());
  }
}
