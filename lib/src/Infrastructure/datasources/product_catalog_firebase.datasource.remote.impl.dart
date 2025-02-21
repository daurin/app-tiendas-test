import 'package:app_tiendas/src/Infrastructure/datasources/product_catalog.datasource.remote.dart';
import 'package:app_tiendas/src/domain/dtos/add_product_to_cart.dto.dart';
import 'package:app_tiendas/src/domain/dtos/get_product_cart.dto.dart';
import 'package:app_tiendas/src/domain/entities/cart_product.entity.dart';
import 'package:app_tiendas/src/domain/entities/product.entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductCatalogFirebaseRemoteDataSourceImpl
    implements ProductCatalogRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addProductToCart(AddProductToCartDto params) async {
    try {
      await _firestore.collection('cart').doc(params.productId).set({
        'quantity': params.quantity,
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      QuerySnapshot<Map<String, dynamic>> cartSnapshot =
          await _firestore.collection('cart').get();
      WriteBatch batch = _firestore.batch();
      for (var doc in cartSnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<GetCartDto?> getCart() async {
    try {
      QuerySnapshot<Map<String, dynamic>> cartSnapshot =
          await _firestore.collection('cart').get();
      List<CartProductEntity> cartProducts = cartSnapshot.docs
          .map((e) => CartProductEntity(
                productId: e.id,
                quantity: e.data()['quantity'],
              ))
          .toList();

      List<ProductEntity> products = [];
      if (cartProducts.isNotEmpty) {
        QuerySnapshot<Map<String, dynamic>> productsSnapshot = await _firestore
            .collection('products')
            .where(
              FieldPath.documentId,
              whereIn: cartProducts.map((e) => e.productId).toList(),
            )
            .get();

        products = productsSnapshot.docs.map((e) {
          Map<String, dynamic> data = e.data();
          return ProductEntity(
            id: e.id,
            name: data['name'],
            price: data['price'],
            description: data['description'],
            imageUrl: data['imageUrl'],
          );
        }).toList();
      }

      double total = 0;
      for (var cartProduct in cartProducts) {
        ProductEntity product = products.firstWhere(
          (element) => element.id == cartProduct.productId,
        );
        total += product.price * cartProduct.quantity;
      }

      return GetCartDto(
        products: products,
        cartProducts: cartProducts,
        total: total,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ProductEntity>> getProducts() async {
    try {
      CollectionReference<Map<String, dynamic>> productsRef =
          _firestore.collection('products');
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await productsRef.get();

      if (querySnapshot.docs.isEmpty) {
        await _addProductTestData();
        querySnapshot = await productsRef.get();
      }

      List<ProductEntity> products = querySnapshot.docs
          .map((e) => ProductEntity(
                id: e.id,
                name: e.data()['name'],
                price: e.data()['price'],
                description: e.data()['description'],
                imageUrl: e.data()['imageUrl'],
              ))
          .toList();

      return products;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeProductFromCart(String productId) async {
    try {
      await _firestore.collection('cart').doc(productId).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _addProductTestData() async {
    WriteBatch batch = _firestore.batch();

    List<Map<String, dynamic>> products = [
      {
        'name': 'Gafas de sol, Lentes Oscuros',
        'price': 4.99,
        'description': '''Gafas de Sol 😎🌞
  Protege tu vista con estilo con nuestras gafas de sol. Diseñadas para bloquear los rayos UV y reducir el deslumbramiento, ofrecen comodidad y un look moderno para cualquier ocasión.

  Lentes Oscuros 🕶️✨
  Dale un toque de misterio y sofisticación a tu outfit con nuestros lentes oscuros. Ideales para días soleados, combinan protección y diseño para que luzcas increíble mientras cuidas tu visión.

  Si quieres un estilo más específico (deportivo, clásico, polarizado, etc.), dime y ajusto las descripciones. 😉''',
        'imageUrl':
            'https://caribebeachwear.com/cdn/shop/products/162217284814e3f12faa8a2a00f7986e649fe70894_1024x1024@2x.jpg?v=1677945114'
      },
      {
        'name': 'COCHE DE HOT WHEELS EN TIRA DE CLIPS ESCALA 1:64',
        'price': 9.99,
        'description':
            '''Coche de Hot Wheels en Tira de Clips - Escala 1:64 🚗🔥

  ¡Colecciona y corre con estilo! Este coche de Hot Wheels en escala 1:64 viene en una práctica tira de clips, ideal para exhibir o transportar tus modelos favoritos. Con detalles realistas y la calidad icónica de Hot Wheels, es perfecto para fanáticos de todas las edades. ¡Añádelo a tu colección y acelera la diversión! 🏁💨''',
        'imageUrl':
            'https://cdn.media.amplience.net/i/frasersdev/40376390_o?fmt=auto&upscale=false&w=1200&h=1200&sm=scaleFit&-ttl'
      },
      {
        'name': 'Mini Truck RC',
        'price': 14.99,
        'description': '''Mini RC Monster Truck - Control Remoto a Escala 🚙💨

  ¡Poder y adrenalina en la palma de tu mano! Este Mini RC Monster Truck combina resistencia y velocidad en un diseño compacto pero robusto. Con neumáticos todoterreno y suspensión de alto rendimiento, es perfecto para superar obstáculos y hacer acrobacias impresionantes. Ideal para interiores y exteriores, disfruta de la acción sin límites con su control remoto preciso y fácil de manejar. ¡Prepárate para la aventura! 🏁🔥''',
        'imageUrl':
            'https://http2.mlstatic.com/D_NQ_NP_2X_997502-CBT81586460854_012025-F.webp'
      },
      {
        'name': 'Casio A158WA Series | Unisex Digital Watch',
        'price': 19.99,
        'description': '''Casio A158WA Series | Reloj Digital Unisex ⌚✨

Un clásico atemporal que nunca pasa de moda. El Casio A158WA combina un diseño retro con funcionalidad moderna, ofreciendo una pantalla digital clara, luz LED, alarma diaria y cronómetro. Su correa de acero inoxidable ajustable y su estructura liviana lo hacen cómodo para el uso diario. Resistente y elegante, es el complemento perfecto para cualquier estilo. ¡Un ícono de la relojería a tu alcance! 🕶️🔥''',
        'imageUrl':
            'https://m.media-amazon.com/images/I/611typKnTvL._AC_SY741_.jpg'
      },
      {
        'name': 'Juego de Mesa Monopoly',
        'price': 24.99,
        'description':
            '''Vaso Térmico de Acero Inoxidable con Aislamiento al Vacío ☕❄️

Mantén tus bebidas a la temperatura perfecta por más tiempo con este vaso térmico de acero inoxidable. Su tecnología de aislamiento al vacío conserva el calor por horas y mantiene las bebidas frías por aún más tiempo. Ideal para café, té, agua o cualquier bebida, es resistente, libre de condensación y perfecto para llevar a la oficina, viajes o aventuras al aire libre. ¡Estilo y funcionalidad en un solo vaso! 🔥🥶''',
        'imageUrl':
            'https://m.media-amazon.com/images/I/51R9+pp918L._AC_SY879_.jpg',
      },
      {
        'name': 'Nintendo Switch Lite - Color Turquesa',
        'price': 196.99,
        'description': '''Nintendo Switch Lite - Color Turquesa 🎮💙

La Nintendo Switch Lite es la consola portátil perfecta para jugar en cualquier lugar. Con un diseño compacto y ligero, está optimizada para el juego en modo portátil, ofreciendo una experiencia cómoda y fluida. Su vibrante color turquesa le da un toque fresco y llamativo. Compatible con una amplia biblioteca de juegos de Nintendo Switch, es ideal para quienes buscan diversión sin límites. ¡Llévala a todas partes y disfruta de tus juegos favoritos! 🕹️✨''',
        'imageUrl':
            'https://m.media-amazon.com/images/I/61owpat34dL._SL1500_.jpg',
      },
    ];

    for (var product in products) {
      DocumentReference<Map<String, dynamic>> docRef =
          _firestore.collection('products').doc();
      batch.set(docRef, product);
    }
    await batch.commit();
  }
}
