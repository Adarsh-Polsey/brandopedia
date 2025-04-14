import 'dart:developer';
import 'package:brandopedia/features/cart/service/cart_database_service.dart';
import 'package:brandopedia/features/home/model/item_model.dart';
import 'package:brandopedia/features/home/repository/home_repository.dart';
import 'package:flutter/foundation.dart';

class CartViewModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  CartViewModel() {
    _loadCartFromDb();
  }

  Future<void> _loadCartFromDb() async {
  final dbData = await CartDbService.getCartItems(); 
  final List<Item> allItems = await HomeRepository().fetchFoodItems();

  _cartItems.clear();
 
  try{
  for (var dbItem in dbData) {
    final match = allItems.firstWhere(
      (item) => item.id == dbItem['foodId'],
    );
    if (match.id.isNotEmpty) {
      final itemMap = match.toMap();
      itemMap['quantity'] = dbItem['quantity']; 
      _cartItems.add(itemMap);
    }
  }
  } catch (e) {
    log("Error: $e");
  }

  notifyListeners();
}

  Future<void> addToCart(Map<String, dynamic> item) async {
  final index = _cartItems.indexWhere((e) => e['id'] == item['id']);
  if (index != -1) {
    _cartItems[index]['quantity'] += 1;
    await CartDbService.increaseQuantity(item['id']);
  } else {
    final newItem = {...item, 'quantity': 1};
    _cartItems.add(newItem);
    await CartDbService.addToCart(newItem);
  }
  notifyListeners();
}

Future<void> removeFromCart(String id) async {
  _cartItems.removeWhere((item) => item['id'] == id);
  await CartDbService.removeFromCart(id);
  notifyListeners();
}

bool isInCart(String id) {
  return _cartItems.any((item) => item['id'] == id);
}

Future<void> increaseQuantity(String id) async {
  final index = _cartItems.indexWhere((item) => item['id'] == id);
  if (index != -1) {
    _cartItems[index]['quantity'] += 1;
    await CartDbService.increaseQuantity(id);
    notifyListeners();
  }
}

Future<void> decreaseQuantity(String id) async {
  final index = _cartItems.indexWhere((item) => item['id'] == id);
  if (index != -1 && _cartItems[index]['quantity'] > 1) {
    _cartItems[index]['quantity'] -= 1;
    await CartDbService.decreaseQuantity(id);
  } else if (index != -1) {
    _cartItems.removeAt(index);
    await CartDbService.removeFromCart(id);
  }
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
}