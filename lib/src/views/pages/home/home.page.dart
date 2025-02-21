import 'package:app_tiendas/src/views/fragments/cart/cart.fragment.dart';
import 'package:app_tiendas/src/views/fragments/products_catalog/product_catalog.fragment.dart';
import 'package:app_tiendas/src/views/pages/home/home.page.controller.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with HomePageController {
  @override
  void initState() {
    super.initState();
    initController();
  }

  @override
  void dispose() {
    disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: ValueListenableBuilder(
          valueListenable: bottomNavigationBarIndexNotifier,
          builder: (context, bottomNavigationBarIndex, child) {
            return IndexedStack(
              index: bottomNavigationBarIndex,
              children: [
                ProductCatalogFragment(),
                CartFragment(),
              ],
            );
          }),
      bottomNavigationBar: ValueListenableBuilder(
          valueListenable: bottomNavigationBarIndexNotifier,
          builder: (context, index, child) {
            return NavigationBar(
              selectedIndex: index,
              onDestinationSelected: onNavigationBarIndexChanged,
              destinations: [
                NavigationDestination(
                  icon: Icon(Icons.home),
                  label: 'Productos',
                ),
                NavigationDestination(
                  icon: Icon(Icons.shopping_cart),
                  label: 'Carrito',
                ),
              ],
            );
          }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(56),
      child: ValueListenableBuilder(
          valueListenable: bottomNavigationBarIndexNotifier,
          builder: (context, bottomNavigationBarIndex, child) {
            if (bottomNavigationBarIndex == 0) {
              return AppBar(
                title: Text('Productos'),
              );
            }

            return AppBar(
              title: Text('Carrito'),
            );
          }),
    );
  }
}
