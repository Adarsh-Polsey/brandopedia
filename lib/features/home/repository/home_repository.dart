import 'package:brandopedia/features/home/model/item_model.dart';

class HomeRepository {
  // Dummy data
  final List<Map<String, dynamic>> _foodItems = [
  {
    "id": "item_1",
    "name": "Margherita Pizza",
    "category": "Food",
    "price": 249,
    "description": "Classic cheese pizza with tomato sauce and basil.",
    "isVegetarian": true,
    "rating": 4.5,
    "imageUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSh7kebW1rUWql0SkGn4BtXk8p29OUJjHzZiA&s",
  },
  {
    "id": "item_2",
    "name": "Gulab Jamun",
    "category": "Dessert",
    "price": 99,
    "description": "Deep-fried milk solids soaked in rose-flavored sugar syrup.",
    "isVegetarian": true,
    "rating": 4.8,
    "imageUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEwK07UoJddWT9niDE_WxYv9yEao7GXY8vFQ&s",
  },
  {
    "id": "item_3",
    "name": "Chicken Biryani",
    "category": "Food",
    "price": 299,
    "description": "Spicy rice dish with marinated chicken and aromatic spices.",
    "isVegetarian": false,
    "rating": 4.7,
    "imageUrl": "https://static.vecteezy.com/system/resources/previews/027/144/484/non_2x/delicious-chicken-biryani-isolated-on-transparent-background-png.png",
  },
  {
    "id": "item_4",
    "name": "Masala Dosa",
    "category": "Food",
    "price": 120,
    "description": "South Indian rice crepe with spiced potato filling.",
    "isVegetarian": true,
    "rating": 4.6,
    "imageUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWVmSi7U3a6ZqLcAbDsadgtGO77PKBZQEI2Q&s",
  },
  {
    "id": "item_5",
    "name": "Mango Lassi",
    "category": "Beverage",
    "price": 79,
    "description": "Sweet mango yogurt drink, chilled and refreshing.",
    "isVegetarian": true,
    "rating": 4.4,
    "imageUrl": "https://static.vecteezy.com/system/resources/previews/052/311/559/non_2x/mango-lassi-isolated-on-transparent-background-png.png",
  },
  {
    "id": "item_6",
    "name": "Paneer Butter Masala",
    "category": "Food",
    "price": 220,
    "description": "Creamy tomato curry with soft paneer cubes.",
    "isVegetarian": true,
    "rating": 4.5,
    "imageUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyMLoAm2MlDY_IyNdxg9Ry2aeotAjrhMztTA&s",
  },
  {
    "id": "item_7",
    "name": "Cold Coffee",
    "category": "Beverage",
    "price": 89,
    "description": "Iced coffee blended with milk and sugar.",
    "isVegetarian": true,
    "rating": 4.3,
    "imageUrl": "https://static.vecteezy.com/system/resources/thumbnails/021/028/232/small/iced-coffee-or-caffe-latte-in-cup-file-png.png",
  },
  {
    "id": "item_8",
    "name": "Butter Naan",
    "category": "Food",
    "price": 45,
    "description": "Soft Indian bread brushed with butter.",
    "isVegetarian": true,
    "rating": 4.2,
    "imageUrl": "https://static.vecteezy.com/system/resources/previews/047/447/283/non_2x/garlic-butter-naan-bread-isolated-on-a-transparent-background-free-png.png",
  },
  {
    "id": "item_9",
    "name": "Veg Hakka Noodles",
    "category": "Food",
    "price": 180,
    "description": "Stir-fried noodles with mixed vegetables and sauces.",
    "isVegetarian": true,
    "rating": 4.1,
    "imageUrl": "https://static.vecteezy.com/system/resources/previews/035/913/330/non_2x/ai-generated-a-bowl-of-chinese-noodles-isolated-on-a-transparent-background-top-view-png.png",
  },
  {
    "id": "item_10",
    "name": "Chocolate Milkshake",
    "category": "Beverage",
    "price": 110,
    "description": "Creamy shake made with chocolate and milk.",
    "isVegetarian": true,
    "rating": 4.6,
    "imageUrl": "https://static.vecteezy.com/system/resources/previews/025/140/281/non_2x/chocolate-milkshake-on-plastic-cup-transparent-background-ai-generated-free-png.png",
  },
];

  Future<List<Item>> fetchFoodItems() async {
    await Future.delayed(const Duration(seconds: 1));
    List<Item> items = _foodItems.map((item) => Item.fromMap(item)).toList();
    return items;
  }
}
