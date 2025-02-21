class CartProductEntity {
  final String productId;
  final int quantity;

  CartProductEntity({
    required this.productId,
    required this.quantity,
  });

  CartProductEntity copyWith({
    String? productId,
    String? name,
    double? price,
    int? quantity,
  }) {
    return CartProductEntity(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
    );
  }
}
