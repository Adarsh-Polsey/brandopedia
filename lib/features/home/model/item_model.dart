import 'package:flutter/material.dart';

class ItemModel extends ChangeNotifier{
  String name;
  String category;
  double price;
  String description;
  bool isVegetarian;
  double rating;
  String imageUrl;

  ItemModel({
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.isVegetarian,
    required this.rating,
    required this.imageUrl,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      name: json['name'],
      category: json['category'],
      price: json['price'].toDouble(),
      description: json['description'],
      isVegetarian: json['isVegetarian'],
      rating: json['rating'].toDouble(),
      imageUrl: json['imageUrl'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'price': price,
      'description': description,
      'isVegetarian': isVegetarian,
      'rating': rating,
      'imageUrl': imageUrl,
    };
  }
  @override
  String toString() {
    return 'ItemModel{name: $name, category: $category, price: $price, description: $description, isVegetarian: $isVegetarian, rating: $rating, imageUrl: $imageUrl}';
  }
}