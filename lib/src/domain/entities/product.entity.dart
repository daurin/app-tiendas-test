class ProductEntity{
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl
  });

  factory ProductEntity.fromMap(Map<String, dynamic> map){
    return ProductEntity(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      imageUrl: map['image']
    );
  }

  ProductEntity copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl
  }){
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl
    );
  }
}