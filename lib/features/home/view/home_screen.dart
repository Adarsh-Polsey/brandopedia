import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:brandopedia/common/app_theme.dart';
import 'package:brandopedia/features/home/widgets/item_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
final List<Map<String, dynamic>> foodItems = [
  {
    "name": "Margherita Pizza",
    "category": "Food",
    "price": 249,
    "description": "Classic cheese pizza with tomato sauce and basil.",
    "isVegetarian": true,
    "rating": 4.5,
    "imageUrl": "https://dummyimage.com/600x400/ffcc00/000000&text=Pizza"
  },
  {
    "name": "Gulab Jamun",
    "category": "Dessert",
    "price": 99,
    "description": "Deep-fried milk solids soaked in rose-flavored sugar syrup.",
    "isVegetarian": true,
    "rating": 4.8,
    "imageUrl": "https://dummyimage.com/600x400/ff99cc/000000&text=Gulab+Jamun"
  },
  {
    "name": "Chicken Biryani",
    "category": "Food",
    "price": 299,
    "description": "Spicy rice dish with marinated chicken and aromatic spices.",
    "isVegetarian": false,
    "rating": 4.7,
    "imageUrl": "https://dummyimage.com/600x400/ff9933/000000&text=Biryani"
  },
  {
    "name": "Masala Dosa",
    "category": "Food",
    "price": 120,
    "description": "South Indian rice crepe with spiced potato filling.",
    "isVegetarian": true,
    "rating": 4.6,
    "imageUrl": "https://dummyimage.com/600x400/f4e542/000000&text=Masala+Dosa"
  },
  {
    "name": "Mango Lassi",
    "category": "Beverage",
    "price": 79,
    "description": "Sweet mango yogurt drink, chilled and refreshing.",
    "isVegetarian": true,
    "rating": 4.4,
    "imageUrl": "https://dummyimage.com/600x400/f9c23c/000000&text=Mango+Lassi"
  },
  {
    "name": "Paneer Butter Masala",
    "category": "Food",
    "price": 220,
    "description": "Creamy tomato curry with soft paneer cubes.",
    "isVegetarian": true,
    "rating": 4.5,
    "imageUrl": "https://dummyimage.com/600x400/ff3300/ffffff&text=Paneer"
  },
  {
    "name": "Cold Coffee",
    "category": "Beverage",
    "price": 89,
    "description": "Iced coffee blended with milk and sugar.",
    "isVegetarian": true,
    "rating": 4.3,
    "imageUrl": "https://dummyimage.com/600x400/bfdbfe/000000&text=Cold+Coffee"
  },
  {
    "name": "Butter Naan",
    "category": "Food",
    "price": 45,
    "description": "Soft Indian bread brushed with butter.",
    "isVegetarian": true,
    "rating": 4.2,
    "imageUrl": "https://dummyimage.com/600x400/fde68a/000000&text=Naan"
  },
  {
    "name": "Veg Hakka Noodles",
    "category": "Food",
    "price": 180,
    "description": "Stir-fried noodles with mixed vegetables and sauces.",
    "isVegetarian": true,
    "rating": 4.1,
    "imageUrl": "https://dummyimage.com/600x400/7dd3fc/000000&text=Noodles"
  },
  {
    "name": "Chocolate Milkshake",
    "category": "Beverage",
    "price": 110,
    "description": "Creamy shake made with chocolate and milk.",
    "isVegetarian": true,
    "rating": 4.6,
    "imageUrl": "https://dummyimage.com/600x400/9ca3af/000000&text=Milkshake"
  },
];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Text(
          " Chennai",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leadingWidth: 100,
        actions: [
          IconButton(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all<Color>(
                AppColorpallete.secondaryColor,
              ),
              backgroundColor: WidgetStateProperty.all<Color>(
                AppColorpallete.primaryColor,
              ),
            ),
            onPressed: () {Navigator.pushNamed(context, '/cart');},
            icon: Icon(Icons.person),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        scrollDirection: Axis.vertical,
        children: [
          // Search TextField
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search for restaurants or dishes...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: _searchController.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        _searchController.clear();
                      },
                      icon: const Icon(Icons.clear),
                    ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(35),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(35),
              ),
              filled: true,
              fillColor: Colors.grey.shade200,
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
          const SizedBox(height: 20),

          // Category Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCategory(Icons.local_pizza, 'Food'),
              _buildCategory(Icons.local_cafe, 'Beverages'),
              _buildCategory(Icons.local_offer, 'Offers'),
              _buildCategory(Icons.favorite, 'Favorites'),
            ],
          ),

          const SizedBox(height: 20),

          // Offers Grid
          SizedBox(height: 200,
            child: Row(children: [
              Expanded(flex: 1,
                child: _buildOfferCard("50% off", "Get it now", [AppColorpallete.sideColor1.withAlpha(150),AppColorpallete.sideColor1]),
              ),
                    const SizedBox(width: 10),

              Flexible(flex: 1,
                child: Column(mainAxisSize:MainAxisSize.max,
                  children: [
                    Expanded(child: _buildOfferCard("30% off", "Try it now", [AppColorpallete.sideColor2.withAlpha(150),AppColorpallete.sideColor2],button:false)),
                    const SizedBox(height: 10),
                    Expanded(child: _buildOfferCard("50% off", "USE 302406",[AppColorpallete.sideColor3.withAlpha(150),AppColorpallete.sideColor3],button: false)),
                  ],
                ),
              )
            ],),
          ),

          const SizedBox(height: 20),
          Center(child: Text("Explore", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),


          // Item Card
          ListView.builder(itemBuilder:(context,index)=> FoodItemCard(item: foodItems[index]), itemCount: foodItems.length, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),),

          Center(child: AnimatedTextKit(
            repeatForever: true,
              animatedTexts: [
                ColorizeAnimatedText(
                  "TheBrandopedia",
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  speed: const Duration(milliseconds: 250),
                  colors: [
                    AppColorpallete.primaryColor.withAlpha(200),
                    AppColorpallete.primaryColor.withAlpha(150),
                    AppColorpallete.primaryColor,
                    AppColorpallete.primaryColor.withAlpha(150),
                    AppColorpallete.primaryColor.withAlpha(200),
                  ],
                ),
              ],
            ),)
        ],
      ),
    );
  }

  Widget _buildCategory(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.deepPurple.shade50,
          child: Icon(icon, color: Colors.deepPurple),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }

  Widget _buildOfferCard(String text, String subTitle, List<Color> color,{bool button=true}) {
    return Container(
      constraints: BoxConstraints.expand(),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: color,begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          button?           ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 12),
                minimumSize: Size(20, 28),
                textStyle: TextStyle(fontSize: 12),
              ),
              onPressed: () {},
              child: Text(subTitle),
            ):Text(subTitle,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
