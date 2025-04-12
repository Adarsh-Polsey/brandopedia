import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:brandopedia/common/app_theme.dart';
import 'package:brandopedia/features/cart/viewmodel/cart_viewmodel.dart';
import 'package:brandopedia/features/home/model/item_model.dart';
import 'package:brandopedia/features/home/viewmodel/home_viewmodel.dart';
import 'package:brandopedia/features/home/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Future.microtask((){
      context.read<HomeViewModel>().fetchFoodItems();
    });
  }
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
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
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
              suffixIcon:
                  _searchController.text.isEmpty
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
              context.read<HomeViewModel>().searchItems(value);
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
          SizedBox(
            height: 200,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: _buildOfferCard("50% off", "Get it now", [
                    AppColorpallete.sideColor1.withAlpha(150),
                    AppColorpallete.sideColor1,
                  ]),
                ),
                const SizedBox(width: 10),

                Flexible(
                  flex: 1,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: _buildOfferCard("30% off", "Try it now", [
                          AppColorpallete.sideColor2.withAlpha(150),
                          AppColorpallete.sideColor2,
                        ], button: false),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: _buildOfferCard("50% off", "USE 302406", [
                          AppColorpallete.sideColor3.withAlpha(150),
                          AppColorpallete.sideColor3,
                        ], button: false),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Center(
            child: Text(
              "Explore",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),

          // Item Card
          Builder(
            builder: (context) {
              final List<Item> foodItems = context.watch<HomeViewModel>().foodItems;
              if(context.watch<HomeViewModel>().isLoading){
                return const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 40)
                    ],
                  ),
                );
              }else if(context.watch<HomeViewModel>().foodItems.isNotEmpty){
              return ListView.builder(
                itemBuilder:
                    (context, index) => FoodItemCard(item: foodItems[index].toMap(), cartOnTap: () { context.read<CartViewModel>().addToCart(foodItems[index].toMap()); },),
                itemCount: foodItems.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              );}
              else{
                return const Center(
                  child: Column(
                    children: [
                      Text("No items found"),
                      SizedBox(height: 40),
                    ],
                  ),
                );
              }
              
            },
          ),

          Center(
            child: AnimatedTextKit(
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
            ),
          ),
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

  Widget _buildOfferCard(
    String text,
    String subTitle,
    List<Color> color, {
    bool button = true,
  }) {
    return Container(
      constraints: BoxConstraints.expand(),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: color,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          button
              ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  minimumSize: Size(20, 28),
                  textStyle: TextStyle(fontSize: 12),
                ),
                onPressed: () {},
                child: Text(subTitle),
              )
              : Text(
                subTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ],
      ),
    );
  }
}
