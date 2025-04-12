import 'package:flutter/material.dart';

class CartViewModel extends ChangeNotifier{
  List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  void addToCart(Map<String, dynamic> item) {
    _cartItems.add(item);
    notifyListeners();
  }

  void removeFromCart(Map<String, dynamic> item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  double get totalPrice {
    return _cartItems.fold(0, (total, item) => total + item['price']);
  }
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  int get itemCount {
    return _cartItems.length;
  }
  
  bool isInCart(Map<String, dynamic> item) {
    return _cartItems.contains(item);
  }
  
  void toggleItem(Map<String, dynamic> item) {
    if (isInCart(item)) {
      removeFromCart(item);
    } else {
      addToCart(item);
    }
  }
  void updateItemQuantity(Map<String, dynamic> item, int quantity) {
    int index = _cartItems.indexOf(item);
    if (index != -1) {
      _cartItems[index]['quantity'] = quantity;
      notifyListeners();
    }
  }
}