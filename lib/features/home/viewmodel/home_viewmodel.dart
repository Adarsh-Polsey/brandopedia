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
  }

  void applyFilters({String? category, double? minPrice, double? maxPrice}) {

    // Update filter state
    _currentCategory = category;
    if (minPrice != null) _minPrice = minPrice;
    if (maxPrice != null) _maxPrice = maxPrice;

    _applyAllFilters();
  }

  void _applyAllFilters() {
    // Start with all items
    _filteredItems = _allItems;

    // Apply search filter if there's a query
    if (_searchQuery.isNotEmpty) {
      _filteredItems =
          _filteredItems.where((item) {
            return item.name.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();
    }

    // Apply category filter if a category is selected
    if (_currentCategory != null && _currentCategory!.isNotEmpty) {
      _filteredItems =
          _filteredItems.where((item) {
            return item.category.toLowerCase() ==
                _currentCategory!.toLowerCase();
          }).toList();
    }else{
      _filteredItems=_allItems;
    }
    _filteredItems =
        _filteredItems.where((item) {
          return item.price >= _minPrice && item.price <= _maxPrice;
        }).toList();
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
