import 'package:app_tiendas/src/views/fragments/products_catalog/product_catalog.fragment.controller.dart';
import 'package:app_tiendas/src/views/providers/cart.provider.dart';
import 'package:app_tiendas/src/views/providers/product_catalog.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCatalogFragment extends StatefulWidget {
  const ProductCatalogFragment({super.key});

  @override
  State<ProductCatalogFragment> createState() => _ProductCatalogFragmentState();
}

class _ProductCatalogFragmentState extends State<ProductCatalogFragment>
    with ProductCatalogFragmentController {
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
    ProductCatalogProvider productCatalogProvider =
        context.watch<ProductCatalogProvider>();

    if (productCatalogProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      itemCount: productCatalogProvider.products.length,
      itemBuilder: (context, index) {
        final product = productCatalogProvider.products[index];

        return Builder(builder: (context) {
          bool isProductInCart = context.select<CartProvider, bool>(
            (provider) => provider.isProductInCart(product.id),
          );

          return _buildProductCard(
            productName: product.name,
            productPrice: '\$${product.price}',
            urlImage: product.imageUrl,
            isProductInCart: isProductInCart,
            onTap: () => onTapProduct(product.id),
            onTapAddToCart: () => addProductToCart(product.id),
            onTapRemoveFromCart: () => onTapRemoveFromCart(product.id),
          );
        });
      },
    );
  }

  Widget _buildProductCard({
    required String productName,
    required String productPrice,
    required String urlImage,
    bool isProductInCart = false,
    void Function()? onTap,
    void Function()? onTapAddToCart,
    void Function()? onTapRemoveFromCart,
  }) {
    return SizedBox(
      height: 180,
      child: Card(
        clipBehavior: Clip.antiAlias,
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
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.tonalIcon(
                          icon: isProductInCart
                              ? Icon(Icons.remove_shopping_cart)
                              : Icon(Icons.add_shopping_cart),
                          label: isProductInCart
                              ? Text('Quitar del carrito')
                              : Text('Agregar al carrito'),
                          onPressed: isProductInCart
                              ? onTapRemoveFromCart
                              : onTapAddToCart,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
