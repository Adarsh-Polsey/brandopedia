class Item {
  final String name;
  final String category;
  final double price;
  final String description;
  final double rating;
  final String imageUrl;

  Item({
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.rating,
    required this.imageUrl,
  });

  factory Item.fromMap(Map<String, dynamic> map) => Item(
    name: map['name'],
    category: map['category'],
    price: map['price'].toDouble(),
    description: map['description'],
    rating: map['rating'].toDouble(),
    imageUrl: map['imageUrl'],
  );

  Map<String, dynamic> toMap() => {
    'name': name,
    'category': category,
    'price': price,
    'description': description,
    'rating': rating,
    'imageUrl': imageUrl,
  };
}