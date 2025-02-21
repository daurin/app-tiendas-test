class AddProductToCartDto {
  final String productId;
  final int quantity;

  AddProductToCartDto({
    required this.productId,
    this.quantity = 1,
  });
}