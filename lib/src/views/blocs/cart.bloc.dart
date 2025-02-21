import 'package:app_tiendas/src/app.dart';
import 'package:app_tiendas/src/domain/dtos/add_product_to_cart.dto.dart';
import 'package:app_tiendas/src/domain/dtos/get_product_cart.dto.dart';
import 'package:app_tiendas/src/domain/entities/cart_product.entity.dart';
import 'package:app_tiendas/src/domain/repositories/product_catalog.repository.dart';
import 'package:app_tiendas/src/views/blocs/product_catalog.bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class CartBloc extends ChangeNotifier {
  bool isLoading = true;
  GetCartDto? cart;

  Future<GetCartDto?> getCart() async {
    if (!isLoading) {
      isLoading = true;
      notifyListeners();
    }
    cart = await GetIt.instance<ProductCatalogRepository>().getCart();
    isLoading = false;
    notifyListeners();
    return cart;
  }

  Future<void> addProductToCart(AddProductToCartDto params) async {
    if (!isProductInCart(params.productId)) {
      cart?.products.add(navigatorContext
          .read<ProductCatalogBloc>()
          .getProductById(params.productId)!);
      cart?.cartProducts.add(CartProductEntity(
          productId: params.productId, quantity: params.quantity));
    } else {
      cart = cart!.copyWith(
          cartProducts: cart!.cartProducts.map((e) {
        if (e.productId == params.productId) {
          return e.copyWith(quantity: params.quantity);
        }
        return e;
      }).toList());
    }

    await GetIt.instance<ProductCatalogRepository>().addProductToCart(params);
    _refreshTotal();
    notifyListeners();
  }

  Future<void> removeProductFromCart(String productId) async {
    cart!.products.removeWhere((element) => element.id == productId);
    cart!.cartProducts.removeWhere((element) => element.productId == productId);
    await GetIt.instance<ProductCatalogRepository>()
        .removeProductFromCart(productId);
    _refreshTotal();
    notifyListeners();
  }

  Future<void> claerCart() async {
    isLoading = true;
    cart?.cartProducts.clear();
    cart?.products.clear();
    await GetIt.instance<ProductCatalogRepository>().clearCart();
    isLoading = false;
    notifyListeners();
  }

  bool isProductInCart(String productId) {
    if (cart == null) return false;
    if (cart!.products.isEmpty) return false;

    return cart!.products.any((element) => element.id == productId);
  }

  void _refreshTotal() {
    if (cart == null) return;
    if (cart!.products.isEmpty) return;

    double total = 0;
    for (var cartProduct in cart!.cartProducts) {
      ProductEntity product = cart!.products
          .firstWhere((element) => element.id == cartProduct.productId);
      total += product.price * cartProduct.quantity;
    }
    cart = cart!.copyWith(total: total);
  }

  String get totalFormatted {
    return '\$${cart?.total.toStringAsFixed(2) ?? '0.00'}';
  }
}
