import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:brandopedia/common/app_theme.dart';
import 'package:brandopedia/features/cart/viewmodel/cart_viewmodel.dart';
import 'package:brandopedia/features/home/viewmodel/home_viewmodel.dart';
import 'package:brandopedia/features/home/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  RangeValues _priceRange = const RangeValues(0, 1000);
  bool _showFilters = false;

  // For location selection
  String _selectedLocation = "Chennai";
  final List<String> _availableLocations = [
    "Chennai",
    "Bangalore",
    "Mumbai",
    "Delhi",
    "Hyderabad",
  ];
  bool _showLocationPicker = false;

  // For animations
  late AnimationController _offerAnimationController;
  late AnimationController _categoryAnimationController;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _offerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _categoryAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();

    Future.microtask(() {
      context.read<HomeViewModel>().fetchFoodItems();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _offerAnimationController.dispose();
    _categoryAnimationController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    context.read<HomeViewModel>().applyFilters(
      category: _selectedCategory == 'All' ? null : _selectedCategory,
      minPrice: _priceRange.start,
      maxPrice: _priceRange.end,
    );
  }

  void _showLocationSelectionDialog() {
    setState(() {
      _showLocationPicker = !_showLocationPicker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 50,
        elevation: 0,foregroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,scrolledUnderElevation: 0,
        title: AnimatedTextKit(
          repeatForever: true,
          animatedTexts: [
            ColorizeAnimatedText(
              "TheBrandopedia",
              textStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              speed: const Duration(milliseconds: 700),
              colors: [
                AppColorpallete.primaryColor,
                Colors.purple,
                AppColorpallete.primaryColor,
              ],
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: _showLocationSelectionDialog,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.location_on,
                color: AppColorpallete.primaryColor,
                size: 22,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 10),
                  child: Column(
                    children: [
                      // Search and Filter Row
                      Row(
                        children: [
                          // Search TextField
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search for restaurants or dishes...',
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                suffixIcon:
                                    _searchController.text.isEmpty
                                        ? null
                                        : IconButton(
                                          onPressed: () {
                                            _searchController.clear();
                                            context
                                                .read<HomeViewModel>()
                                                .searchItems('');
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
                                context.read<HomeViewModel>().searchItems(
                                  value,
                                );
                              },
                            ),
                          ),
                          IconButton(
                            icon: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 60),
                              transitionBuilder: (
                                Widget child,
                                Animation<double> animation,
                              ) {
                                return RotationTransition(
                                  turns: animation,
                                  child: child,
                                );
                              },
                              child: Icon(
                                _showFilters ? Icons.close : Icons.filter_list,
                                key: ValueKey<bool>(_showFilters),
                                color: AppColorpallete.primaryColor,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _showFilters = !_showFilters;
                              });
                            },
                          ),
                        ],
                      ),

                      // Filter Panel with Animation
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: _showFilters ? 180 : 0,
                        curve: Curves.easeInOut,
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Price Range",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '₹${_priceRange.start.round()} - ₹${_priceRange.end.round()}',
                                    style: TextStyle(
                                      color: AppColorpallete.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              RangeSlider(
                                values: _priceRange,
                                min: 0,
                                max: 1000,
                                divisions: 10,
                                activeColor: AppColorpallete.primaryColor,
                                labels: RangeLabels(
                                  '₹${_priceRange.start.round()}',
                                  '₹${_priceRange.end.round()}',
                                ),
                                onChanged: (RangeValues values) {
                                  setState(() {
                                    _priceRange = values;
                                  });
                                },
                                onChangeEnd: (RangeValues values) {
                                  _applyFilters();
                                },
                              ),
                              Center(
                                child: ElevatedButton.icon(
                                  onPressed: _applyFilters,
                                  icon: const Icon(Icons.check),
                                  label: const Text("Apply Filters"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppColorpallete.primaryColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Category Chips
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCategory(
                          _selectedCategory == 'Food'?Icons.food_bank_outlined:Icons.local_pizza,
                          _selectedCategory == 'Food'?'All':'Food',
                          onTap: () => _selectedCategory == 'Food'?_selectCategory('All'):_selectCategory('Food'),
                        ),
                        _buildCategory(
                          _selectedCategory == 'Beverage'?Icons.food_bank_outlined:Icons.local_cafe,
                          _selectedCategory == 'Beverage'?'All':'Beverage',
                          onTap: () =>  _selectedCategory == 'Beverage'?_selectCategory('All'):_selectCategory('Beverage'),
                        ),

                        _buildCategory(
                          Icons.local_offer,
                          'Offers',
                          onTap: () => _showOffersDialog(),
                        ),

                        _buildCategory(
                          Icons.favorite,
                          'Favorites',
                          onTap:
                              () => Navigator.pushNamed(context, '/favorites'),
                        ),
                      ],
                    ),
                  ),
                ),

                // Animated Offers Section
                FadeTransition(
                  opacity: _offerAnimationController,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                    ).animate(_offerAnimationController),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        height: 180,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: _buildOfferCard(
                                "50% off",
                                "Get it now",
                                [
                                  AppColorpallete.sideColor1.withAlpha(150),
                                  AppColorpallete.sideColor1,
                                ],
                                onTap: () => _applyPromoCode("FIRST50"),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              flex: 1,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: _buildOfferCard(
                                      "30% off",
                                      "Try it now",
                                      [
                                        AppColorpallete.sideColor2.withAlpha(
                                          150,
                                        ),
                                        AppColorpallete.sideColor2,
                                      ],
                                      button: false,
                                      onTap: () => _applyPromoCode("NEW30"),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Expanded(
                                    child: _buildOfferCard(
                                      "50% off",
                                      "USE 302406",
                                      [
                                        AppColorpallete.sideColor3.withAlpha(
                                          150,
                                        ),
                                        AppColorpallete.sideColor3,
                                      ],
                                      button: false,
                                      onTap: () => _applyPromoCode("302406"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Explore Title
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        colors: [
                          AppColorpallete.primaryColor.withAlpha(200),
                          Colors.deepPurple.withAlpha(180),
                          AppColorpallete.primaryColor.withAlpha(170),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ).createShader(bounds);
                    },
                    child: Column(
                      children: [
                        const Text(
                          "Explore",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                          Text(
                          "What's in $_selectedLocation",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Food Items List with animations
                Consumer<HomeViewModel>(
                  builder: (context, viewModel, _) {
                    if (viewModel.isLoading) {
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return FoodItemCard(
                            item: {},
                            cartOnTap: () {},
                            waiting: true,
                            inCart: false,
                          );
                        },
                        itemCount: 5,
                      );
                    } else if (viewModel.foodItems.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "No items found",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _selectedCategory = 'All';
                                  _priceRange = const RangeValues(0, 1000);
                                });
                                context.read<HomeViewModel>().fetchFoodItems();
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text("Reset Filters"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColorpallete.primaryColor,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        itemCount: viewModel.foodItems.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: FoodItemCard(
                              item: viewModel.foodItems[index].toMap(),
                              cartOnTap:
                                  !context.read<CartViewModel>().isInCart(
                                        viewModel.foodItems[index].name,
                                      )
                                      ? () {
                                        context.read<CartViewModel>().addToCart(
                                          viewModel.foodItems[index].toMap(),
                                        );

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Row(
                                              children: [
                                                const Icon(
                                                  Icons.check_circle,
                                                  color: Colors.white,
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      "Added ${viewModel.foodItems[index].name} to cart",
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            duration: const Duration(
                                              seconds: 1,
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            action: SnackBarAction(
                                              label: 'VIEW CART',
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  '/cart',
                                                );
                                              },
                                            ),
                                            backgroundColor:
                                                AppColorpallete.primaryColor,
                                          ),
                                        );
                                      }
                                      : () {
                                        context
                                            .read<CartViewModel>()
                                            .removeFromCart(
                                              viewModel.foodItems[index].name,
                                            );

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Row(
                                              children: [
                                                const Icon(
                                                  Icons.check_circle,
                                                  color: Colors.white,
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      "Removed ${viewModel.foodItems[index].name} from cart",
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            duration: const Duration(
                                              seconds: 1,
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            action: SnackBarAction(
                                              label: 'VIEW CART',
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  '/cart',
                                                );
                                              },
                                            ),
                                            backgroundColor:
                                                AppColorpallete.primaryColor,
                                          ),
                                        );
                                      },
                              inCart: context.watch<CartViewModel>().isInCart(
                                viewModel.foodItems[index].name,
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),

          // Location picker overlay
          if (_showLocationPicker) _buildLocationPickerOverlay(),
        ],
      ),
    );
  }

  // Location picker overlay
  Widget _buildLocationPickerOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Select Location",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColorpallete.primaryColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _showLocationPicker = false;
                        });
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...List.generate(
                  _availableLocations.length,
                  (index) => ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color:
                          _selectedLocation == _availableLocations[index]
                              ? AppColorpallete.primaryColor
                              : Colors.grey,
                    ),
                    title: Text(_availableLocations[index]),
                    selected: _selectedLocation == _availableLocations[index],
                    selectedTileColor: AppColorpallete.primaryColor.withOpacity(
                      0.1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedLocation = _availableLocations[index];
                        _showLocationPicker = false;
                      });
                      // Refresh food items based on location
                      context.read<HomeViewModel>().fetchFoodItems();
                    },
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _showLocationPicker = false;
                    });
                    // Get current location logic would go here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Getting your current location..."),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    Future.delayed(const Duration(seconds: 2), () {
                      setState(() {
                        _selectedLocation = "Chennai";
                      });
                      context.read<HomeViewModel>().fetchFoodItems();
                    });
                  },
                  icon: const Icon(Icons.my_location),
                  label: const Text("Use Current Location"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColorpallete.primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 45),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods
  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _applyFilters();
  }

  void _showOffersDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 5,
                width: 40,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Text(
                "Available Offers",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColorpallete.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildPromoCard(
                      "FIRST50",
                      "50% off on your first order",
                      "Min order: ₹200",
                    ),
                    _buildPromoCard(
                      "NEW30",
                      "30% off for new users",
                      "Valid until next week",
                    ),
                    _buildPromoCard(
                      "302406",
                      "50% off on selected items",
                      "Limited time offer",
                    ),
                    _buildPromoCard(
                      "FREESHIP",
                      "Free shipping on all orders",
                      "No minimum order",
                    ),
                    _buildPromoCard(
                      "WEEKEND25",
                      "25% off on weekend orders",
                      "Valid Sat-Sun only",
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPromoCard(String code, String description, String condition) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: AppColorpallete.primaryColor),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                code,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColorpallete.primaryColor,
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _applyPromoCode(code);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColorpallete.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text("Apply"),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              condition,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void _applyPromoCode(String code) {
    // In a real app, this would apply the promo code to the cart
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Promo code $code applied!"),
        backgroundColor: AppColorpallete.primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildCategory(
    IconData icon,
    String label, {
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          TweenAnimationBuilder(
            duration: const Duration(milliseconds: 300),
            tween: Tween<double>(begin: 0.8, end: 1.0),
            builder: (context, double value, child) {
              return Transform.scale(scale: value, child: child);
            },
            child: CircleAvatar(
              radius: 28,
              backgroundColor: AppColorpallete.primaryColor.withOpacity(0.1),
              child: Icon(icon, color: AppColorpallete.primaryColor, size: 24),
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildOfferCard(
    String text,
    String subTitle,
    List<Color> color, {
    bool button = true,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: color,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            button
                ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    minimumSize: const Size(20, 28),
                    textStyle: const TextStyle(fontSize: 12),
                    elevation: 0,
                  ),
                  onPressed: onTap,
                  child: Text(subTitle, style: TextStyle(color: color[1])),
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      subTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 14,
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
