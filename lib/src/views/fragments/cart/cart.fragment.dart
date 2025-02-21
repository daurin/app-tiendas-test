import 'package:app_tiendas/src/domain/repositories/product_catalog.repository.dart';
import 'package:app_tiendas/src/views/fragments/cart/cart.fragment.controller.dart';
import 'package:app_tiendas/src/views/blocs/cart.bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartFragment extends StatefulWidget {
  const CartFragment({super.key});

  @override
  State<CartFragment> createState() => _CartFragmentState();
}

class _CartFragmentState extends State<CartFragment>
    with CartFragmentController {
  @override
  void initState() {
    super.initState();
    initStateController();
  }

  @override
  void dispose() {
    disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CartBloc cartBloc = context.watch<CartBloc>();

    if (cartBloc.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (cartBloc.cart?.cartProducts.isEmpty ?? true) {
      return const Center(
        child: Text('Carrito vacío'),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: cartBloc.cart?.products.length ?? 0,
            itemBuilder: (context, index) {
              ProductEntity product = cartBloc.cart!.products[index];

              return ValueListenableBuilder(
                valueListenable: cartQuantityNotifier,
                builder: (context, cartQuantity, child) {
                  int quantity = cartQuantity[product.id] ?? 1;

                  return Column(
                    children: [
                      _buildProductCard(
                        productName: product.name,
                        productPrice: '\$${product.price}',
                        urlImage: product.imageUrl,
                        quantity: quantity,
                        onTapIncraseQuantityCart: () =>
                            onTapIncraseQuantityCart(product.id),
                        onTapDecreaseQuantityCart:
                            (cartQuantity[product.id] ?? 0) > 1
                                ? () => onTapDecreaseQuantityCart(product.id)
                                : null,
                        onTapRemoveFromCart: () =>
                            onTapRemoveFromCart(product.id),
                      ),
                      // if last
                      if (index == cartBloc.cart!.products.length - 1)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(
                            top: 24,
                            left: 16,
                            right: 16,
                          ),
                          child: FilledButton.tonal(
                            style: FilledButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.errorContainer,
                            ),
                            onPressed: onTapClearCart,
                            child: Text('Vaciar carrito'),
                          ),
                        ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total: ${cartBloc.totalFormatted}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonal(
                    child: Text('Finalizar compra'),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard({
    required String productName,
    required String productPrice,
    required String urlImage,
    int quantity = 1,
    void Function()? onTap,
    void Function()? onTapIncraseQuantityCart,
    void Function()? onTapDecreaseQuantityCart,
    void Function()? onTapRemoveFromCart,
  }) {
    return Builder(builder: (context) {
      return SizedBox(
        height: 150,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    urlImage,
                    fit: BoxFit.cover,
                    width: 150,
                    height: 150,
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox(
                        width: 150,
                        height: 150,
                        child: Center(child: const Icon(Icons.error)),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return SizedBox(
                        width: 150,
                        height: 150,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        productPrice,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: SizedBox(
                              width: 150,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 45,
                                    height: 45,
                                    child: MaterialButton(
                                      padding: EdgeInsets.zero,
                                      shape: CircleBorder(),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      onPressed: onTapDecreaseQuantityCart,
                                      child: const Icon(Icons.remove),
                                    ),
                                  ),
                                  IntrinsicHeight(
                                    child: Center(
                                      child: Text(
                                        quantity.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 45,
                                    height: 45,
                                    child: MaterialButton(
                                      padding: EdgeInsets.zero,
                                      shape: CircleBorder(),
                                      onPressed: onTapIncraseQuantityCart,
                                      child: const Icon(Icons.add),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: onTapRemoveFromCart,
                          ),
                          // SizedBox(
                          //   child: FilledButton.tonalIcon(
                          //     icon: isProductInCart
                          //         ? Icon(Icons.remove_shopping_cart)
                          //         : Icon(Icons.add_shopping_cart),
                          //     label: isProductInCart
                          //         ? Text('Quitar del carrito')
                          //         : Text('Agregar al carrito'),
                          //     onPressed: isProductInCart
                          //         ? onTapRemoveFromCart
                          //         : onTapAddToCart,
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
