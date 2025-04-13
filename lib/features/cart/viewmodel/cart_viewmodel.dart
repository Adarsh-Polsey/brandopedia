import 'package:brandopedia/features/cart/service/cart_database_service.dart';
import 'package:flutter/foundation.dart';

class CartViewModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  CartViewModel() {
    _loadCartFromDb();
  }

  Future<void> _loadCartFromDb() async {
    final data = await CartDbService.getCartItems();
    _cartItems.clear();
    _cartItems.addAll(data);
    notifyListeners();
  }

  Future<void> addToCart(Map<String, dynamic> item) async {
    final index = _cartItems.indexWhere((e) => e['name'] == item['name']);
    if (index != -1) {
      _cartItems[index]['quantity'] += 1;
      await CartDbService.increaseQuantity(item['name']);
    } else {
      final newItem = {...item, 'quantity': 1};
      _cartItems.add(newItem);
      await CartDbService.addToCart(newItem);
    }
    notifyListeners();
  }

  Future<void> removeFromCart(String itemName) async {
    _cartItems.removeWhere((item) => item['name'] == itemName);
    await CartDbService.removeFromCart(itemName);
    notifyListeners();
  }

  double get totalPrice {
    return _cartItems.fold(0, (total, item) =>
      total + (item['price'] * (item['quantity'] ?? 1)));
  }

  Future<void> clearCart() async {
    _cartItems.clear();
    await CartDbService.clearCart();
    notifyListeners();
  }

  int get itemCount {
    return _cartItems.fold(0, (count, item) => int.parse((count + (item['quantity'] ?? 1)).toString()));
  }

  bool isInCart(String itemName) {
    return _cartItems.any((item) => item['name'] == itemName);
  }

  Future<void> toggleItem(Map<String, dynamic> item) async {
    if (isInCart(item['name'])) {
      await removeFromCart(item['name']);
    } else {
      await addToCart(item);
    }
  }

  Future<void> increaseQuantity(String itemName) async {
    final index = _cartItems.indexWhere((item) => item['name'] == itemName);
    if (index != -1) {
      _cartItems[index]['quantity'] += 1;
      await CartDbService.increaseQuantity(itemName);
      notifyListeners();
    }
  }

  Future<void> decreaseQuantity(String itemName) async {
    final index = _cartItems.indexWhere((item) => item['name'] == itemName);
    if (index != -1 && _cartItems[index]['quantity'] > 1) {
      _cartItems[index]['quantity'] -= 1;
      await CartDbService.decreaseQuantity(itemName);
    } else if (index != -1) {
      _cartItems.removeAt(index);
      await CartDbService.removeFromCart(itemName);
    }
    notifyListeners();
  }
}