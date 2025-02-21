class AddProductDto{
  final String name;
  final String description;
  final double price;
  final String image;

  AddProductDto({
    required this.name,
    required this.description,
    required this.price,
    required this.image
  });

  AddProductDto copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? image
  }){
    return AddProductDto(
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      image: image ?? this.image
    );
  }
}