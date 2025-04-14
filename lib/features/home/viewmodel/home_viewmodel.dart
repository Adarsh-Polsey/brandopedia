
import 'dart:developer';

import 'package:brandopedia/features/home/model/item_model.dart';
import 'package:brandopedia/features/home/repository/home_repository.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeRepository homeRepository = HomeRepository();

  List<Item> _allItems = [];
  List<Item> _filteredItems = [];
  bool _isLoading = false;

  // Filter state variables
  String? _currentCategory;
  String _searchQuery = '';
  double _minPrice = 0;
  double _maxPrice = 1000;

  List<Item> get foodItems => _filteredItems;
  bool get isLoading => _isLoading;

  void fetchFoodItems() async {
    _isLoading = true;
    notifyListeners();

    _allItems = await homeRepository.fetchFoodItems();
    _filteredItems = _allItems;

    _isLoading = false;
    notifyListeners();
  }

  void searchItems(String query) {
    _searchQuery = query;
    _applyAllFilters();
    notifyListeners();
  }

  void applyFilters({String? category, double? minPrice, double? maxPrice}) {

    // Update filter state
    _currentCategory = category;
    if (minPrice != null) _minPrice = minPrice;
    if (maxPrice != null) _maxPrice = maxPrice;

    _applyAllFilters();
  }

  void _applyAllFilters() {
  _filteredItems = _allItems.where((item) {
    final matchesSearch = _searchQuery.isEmpty ||
        item.name.toLowerCase().contains(_searchQuery.toLowerCase());

    final matchesCategory = _currentCategory == null ||
        _currentCategory!.isEmpty ||
        item.category.toLowerCase() == _currentCategory!.toLowerCase();

    final matchesPrice = item.price >= _minPrice && item.price <= _maxPrice;

    return matchesSearch && matchesCategory && matchesPrice;
  }).toList();

  log("_search: $_searchQuery | category: $_currentCategory | result count: ${_filteredItems.length}");
  notifyListeners();
}

  // Reset all filters
  void resetFilters() {
    _currentCategory = null;
    _searchQuery = '';
    _minPrice = 0;
    _maxPrice = 1000;
    _filteredItems = _allItems;
    notifyListeners();
  }
}
