import 'package:app_tiendas/src/domain/repositories/product_catalog.repository.dart';
import 'package:app_tiendas/src/views/pages/product_details/product_details.page.controller.dart';
import 'package:app_tiendas/src/views/providers/cart.provider.dart';
import 'package:app_tiendas/src/views/providers/product_catalog.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productId;

  const ProductDetailsPage({super.key, required this.productId});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage>
    with ProductDetailsPageController {
  @override
  void initState() {
    super.initState();
    initStateController(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    ProductEntity? product =
        context.select<ProductCatalogProvider, ProductEntity?>(
            (provider) => provider.getProductById(widget.productId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Producto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: onTapCart,
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (product == null) {
            return Center(
              child: Text('Producto no encontrado'),
            );
          }

          return ListView(
            children: [
              LimitedBox(
                maxHeight: 400,
                child: Image.network(
                  product.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.fitHeight,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: child,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                  bottom: 24,
                ),
                child: Column(
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${product.price}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      product.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  Widget _buildBottomAppBar() {
    return Builder(builder: (context) {
      bool isProductInCart = context.select<CartProvider, bool>(
        (provider) => provider.isProductInCart(widget.productId),
      );

      return BottomAppBar(
        child: Row(
          children: [
            ValueListenableBuilder(
              valueListenable: cartQuantityNotifier,
              builder: (context, cartQuantity, child) {
                return Visibility(
                  visible: !isProductInCart,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // const Icon(Icons.remove),
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: MaterialButton(
                              padding: EdgeInsets.zero,
                              shape: CircleBorder(),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              onPressed: cartQuantity > 1
                                  ? decrementCartQuantity
                                  : null,
                              child: const Icon(Icons.remove),
                            ),
                          ),
                          IntrinsicHeight(
                            child: Center(
                              child: Text(
                                cartQuantity == 0
                                    ? '1'
                                    : cartQuantity.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: MaterialButton(
                              padding: EdgeInsets.zero,
                              shape: CircleBorder(),
                              onPressed: incrementCartQuantity,
                              child: const Icon(Icons.add),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            if (!isProductInCart) const SizedBox(width: 16),
            if (isProductInCart)
              Expanded(
                child: FilledButton.tonalIcon(
                  label: Text('Quitar del carrito'),
                  icon: const Icon(Icons.remove_shopping_cart),
                  onPressed: removeFromCart,
                ),
              )
            else
              Expanded(
                child: FilledButton.tonalIcon(
                  label: Text('Agregar al carrito'),
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: addToCart,
                ),
              ),
          ],
        ),
      );
    });
  }
}
