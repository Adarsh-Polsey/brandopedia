import 'dart:developer';

import 'package:brandopedia/features/home/model/item_model.dart';
import 'package:brandopedia/features/home/repository/home_repository.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeRepository homeRepository = HomeRepository();

  List<Item> _allItems = [];
  List<Item> _filteredItems = [];
  bool _isLoading = false;

  List<Item> get foodItems => _filteredItems;
  bool get isLoading => _isLoading;

  void fetchFoodItems() async {
    log("Fetching food items");
    _isLoading = true;
    notifyListeners();
    _allItems = await homeRepository.fetchFoodItems();
    _filteredItems = _allItems;
    _isLoading = false;
    notifyListeners();
  }

  void searchItems(String query) {
    if (query.isEmpty) {
      _filteredItems = _allItems;
      notifyListeners();
    } else {
      _filteredItems =
          _allItems.where((item) {
            return item.name.toLowerCase().contains(query.toLowerCase());
          }).toList();
      notifyListeners();
    }
  }

  void filterCategory(){  }
}
