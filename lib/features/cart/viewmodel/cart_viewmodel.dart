import 'package:flutter/material.dart';

class CartViewModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  void addToCart(Map<String, dynamic> item) {
    final index = _cartItems.indexWhere((e) => e['name'] == item['name']);
    if (index != -1) {
      _cartItems[index]['quantity'] += 1;
    } else {
      _cartItems.add({...item, 'quantity': 1});
    }
    notifyListeners();
  }

  void removeFromCart(String itemName) {
    _cartItems.removeWhere((item) => item['name'] == itemName);
    notifyListeners();
  }

  double get totalPrice {
    return _cartItems.fold(0, (total, item) =>
      total + (item['price'] * (item['quantity'] ?? 1)));
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  int get itemCount {
    return _cartItems.fold(0, (count, item) => int.parse((count + (item['quantity'] ?? 1)).toString()));
  }

  bool isInCart(String itemName) {
    return _cartItems.any((item) => item['name'] == itemName);
  }

  void toggleItem(Map<String, dynamic> item) {
    if (isInCart(item['name'])) {
      removeFromCart(item['name']);
    } else {
      addToCart(item);
    }
  }

  void increaseQuantity(String itemName) {
    final index = _cartItems.indexWhere((item) => item['name'] == itemName);
    if (index != -1) {
      _cartItems[index]['quantity'] += 1;
      notifyListeners();
    }
  }

  void decreaseQuantity(String itemName) {
    final index = _cartItems.indexWhere((item) => item['name'] == itemName);
    if (index != -1 && _cartItems[index]['quantity'] > 1) {
      _cartItems[index]['quantity'] -= 1;
    } else if (index != -1) {
      _cartItems.removeAt(index);
    }
    notifyListeners();
  }

  void updateItemQuantity(String itemName, int quantity) {
    final index = _cartItems.indexWhere((item) => item['name'] == itemName);
    if (index != -1) {
      _cartItems[index]['quantity'] = quantity;
      notifyListeners();
    }
  }
}