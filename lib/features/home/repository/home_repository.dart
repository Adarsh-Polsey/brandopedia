import 'package:brandopedia/features/home/model/item_model.dart';

class HomeRepository {
  // Dummy data
  final List<Map<String, dynamic>> _foodItems = [
  {
    "id": 1,
    "name": "Margherita Pizza",
    "category": "Food",
    "price": 249,
    "description": "Classic cheese pizza with tomato sauce and basil.",
    "isVegetarian": true,
    "rating": 4.5,
    "imageUrl": "https://dummyimage.com/600x400/ffcc00/000000&text=Pizza",
  },
  {
    "id": 2,
    "name": "Gulab Jamun",
    "category": "Dessert",
    "price": 99,
    "description": "Deep-fried milk solids soaked in rose-flavored sugar syrup.",
    "isVegetarian": true,
    "rating": 4.8,
    "imageUrl": "https://dummyimage.com/600x400/ff99cc/000000&text=Gulab+Jamun",
  },
  {
    "id": 3,
    "name": "Chicken Biryani",
    "category": "Food",
    "price": 299,
    "description": "Spicy rice dish with marinated chicken and aromatic spices.",
    "isVegetarian": false,
    "rating": 4.7,
    "imageUrl": "https://dummyimage.com/600x400/ff9933/000000&text=Biryani",
  },
  {
    "id": 4,
    "name": "Masala Dosa",
    "category": "Food",
    "price": 120,
    "description": "South Indian rice crepe with spiced potato filling.",
    "isVegetarian": true,
    "rating": 4.6,
    "imageUrl": "https://dummyimage.com/600x400/f4e542/000000&text=Masala+Dosa",
  },
  {
    "id": 5,
    "name": "Mango Lassi",
    "category": "Beverage",
    "price": 79,
    "description": "Sweet mango yogurt drink, chilled and refreshing.",
    "isVegetarian": true,
    "rating": 4.4,
    "imageUrl": "https://dummyimage.com/600x400/f9c23c/000000&text=Mango+Lassi",
  },
  {
    "id": 6,
    "name": "Paneer Butter Masala",
    "category": "Food",
    "price": 220,
    "description": "Creamy tomato curry with soft paneer cubes.",
    "isVegetarian": true,
    "rating": 4.5,
    "imageUrl": "https://dummyimage.com/600x400/ff3300/ffffff&text=Paneer",
  },
  {
    "id": 7,
    "name": "Cold Coffee",
    "category": "Beverage",
    "price": 89,
    "description": "Iced coffee blended with milk and sugar.",
    "isVegetarian": true,
    "rating": 4.3,
    "imageUrl": "https://dummyimage.com/600x400/bfdbfe/000000&text=Cold+Coffee",
  },
  {
    "id": 8,
    "name": "Butter Naan",
    "category": "Food",
    "price": 45,
    "description": "Soft Indian bread brushed with butter.",
    "isVegetarian": true,
    "rating": 4.2,
    "imageUrl": "https://dummyimage.com/600x400/fde68a/000000&text=Naan",
  },
  {
    "id": 9,
    "name": "Veg Hakka Noodles",
    "category": "Food",
    "price": 180,
    "description": "Stir-fried noodles with mixed vegetables and sauces.",
    "isVegetarian": true,
    "rating": 4.1,
    "imageUrl": "https://dummyimage.com/600x400/7dd3fc/000000&text=Noodles",
  },
  {
    "id": 10,
    "name": "Chocolate Milkshake",
    "category": "Beverage",
    "price": 110,
    "description": "Creamy shake made with chocolate and milk.",
    "isVegetarian": true,
    "rating": 4.6,
    "imageUrl": "https://dummyimage.com/600x400/9ca3af/000000&text=Milkshake",
  },
];

  Future<List<Item>> fetchFoodItems() async {
    await Future.delayed(const Duration(seconds: 1));
    List<Item> items = _foodItems.map((item) => Item.fromMap(item)).toList();
    return items;
  }
}
