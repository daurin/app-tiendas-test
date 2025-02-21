import 'package:app_tiendas/src/views/events/get_cart.event.dart';
import 'package:app_tiendas/src/views/events/get_products.event.dart';
import 'package:flutter/material.dart';

mixin HomePageController {
  final ValueNotifier bottomNavigationBarIndexNotifier = ValueNotifier<int>(0);


  void initController() async {
    await GetCartEvent().call(NoParams());  
    await GetProductsEvent().call(NoParams());
  }

  void onNavigationBarIndexChanged(int index) {
    bottomNavigationBarIndexNotifier.value = index;
  }

  void disposeController() {
    bottomNavigationBarIndexNotifier.dispose();
  }
  
}