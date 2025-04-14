import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brandopedia/features/cart/viewmodel/cart_viewmodel.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  late AnimationController _checkoutButtonController;
  late Animation<double> _checkoutButtonAnimation;
    
  // For empty cart animation
  late AnimationController _emptyCartController;
  late Animation<double> _emptyCartAnimation;

  @override
  void initState() {
    super.initState();
    
    // Checkout button pulse animation
    _checkoutButtonController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _checkoutButtonAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _checkoutButtonController, curve: Curves.easeInOut)
    );
    
    // Empty cart animation
    _emptyCartController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _emptyCartAnimation = CurvedAnimation(
      parent: _emptyCartController,
      curve: Curves.elasticOut,
    );
    
    // Start empty cart animation if cart is empty
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<CartViewModel>().itemCount == 0) {
        _emptyCartController.forward();
      }
    });
  }

  @override
  void dispose() {
    _checkoutButtonController.dispose();
    _emptyCartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double total = context.watch<CartViewModel>().totalPrice;
    final cartItems = context.watch<CartViewModel>().cartItems;
    
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "My Cart",
          style: TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          AnimatedOpacity(
            opacity: cartItems.isNotEmpty ? 1.0 : 0.3,
            duration: Duration(milliseconds: 300),
            child: IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.deepPurple.shade300),
              onPressed: () {
                if (cartItems.isEmpty) return;
                
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text("Clear Cart?"),
                    content: Text("Are you sure you want to remove all items?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.read<CartViewModel>().clearCart();
                          Navigator.pop(context);
                          _emptyCartController.reset();
                          _emptyCartController.forward();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text("Clear"),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar showing checkout completion
          if (cartItems.isNotEmpty)
            TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              tween: Tween<double>(begin: 0, end: 0.5), // Half completion
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                backgroundColor: Colors.deepPurple.shade50,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                minHeight: 3,
              ),
            ),
          
          Expanded(
            child: cartItems.isEmpty 
              ? _buildEmptyCart()
              : _buildCartItems(cartItems),
          ),

          // Order summary
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: cartItems.isEmpty ? 0 : 250,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha:0.2),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                if (cartItems.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Subtotal",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      TweenAnimationBuilder<double>(
                        duration: Duration(milliseconds: 500),
                        tween: Tween<double>(begin: 0, end: total),
                        builder: (context, value, _) => Text(
                          "₹${value.toStringAsFixed(2)}",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Delivery Fee",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      Text(
                        "₹${total == 0 ? 0 : 40}",
                        style: TextStyle(fontWeight: FontWeight.w500)
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Divider(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      TweenAnimationBuilder<double>(
                        duration: Duration(milliseconds: 500),
                        tween: Tween<double>(begin: 0, end: total == 0 ? 0 : total + 40),
                        builder: (context, value, _) => Text(
                          "₹${value.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
                
                // Enhanced checkout button
                ScaleTransition(
                  scale:_checkoutButtonAnimation,
                  child: ElevatedButton(
                    onPressed: () {
                      // Show a success animation
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.white),
                              SizedBox(width: 10),
                              Text("Order placed successfully!"),
                            ],
                          ),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      disabledBackgroundColor: Colors.deepPurple.shade400,
                      minimumSize: Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_bag_outlined),
                        SizedBox(width: 10),
                        Text(
                           "Checkout Now",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItems(List cartItems) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animated items counter
            TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 500),
              tween: Tween<double>(begin: 0, end: 1),
              builder: (context, value, child) => Opacity(
                opacity: value,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
                  child: Text(
                    "${context.watch<CartViewModel>().itemCount} items in your cart",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ),
            
            // Cart items list
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                // Staggered animation for list items
                return TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 400 + (index * 100)),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: child,
                      ),
                    );
                  },
                  child: Dismissible(
                    key: Key(cartItems[index]['name']),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                    onDismissed: (direction) {
                      context.read<CartViewModel>().removeFromCart(cartItems[index]['id']);
                      
                      // Show undo option
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Item removed from cart"),
                          action: SnackBarAction(
                            label: "UNDO",
                            onPressed: () {
                              // Logic to add item back would go here
                            },
                          ),
                        ),
                      );
                    },
                    child: cartItem(
                      title: cartItems[index]['name'].toString(),
                      subtitle: cartItems[index]['description'].toString(),
                      quantity: cartItems[index]['quantity'],
                      price: cartItems[index]['price'],
                      imageUrl: cartItems[index]['imageUrl'].toString(),
                      onAdd: () {
                        context.read<CartViewModel>().increaseQuantity(cartItems[index]['id']);
                      },
                      onRemove: () {
                        context.read<CartViewModel>().decreaseQuantity(cartItems[index]['id']);
                        if (cartItems[index]['quantity'] == 0) {
                          context.read<CartViewModel>().removeFromCart(cartItems[index]['id']);
                        }
                      },
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 20),

            //coupon section
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 30 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: child,
                  ),
                );
              },
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (context) => _buildCouponBottomSheet(),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha:0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.local_offer, color: Colors.deepPurple),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          "Apply Coupon Code",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "ADD",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Recommended items
            if (cartItems.isNotEmpty) ...[
              SizedBox(height: 30),
              Text(
                "You may also like",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return  Container(
                        width: 240,
                        margin: EdgeInsets.only(right: 16),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha:0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 80,
                                height: 80,
                                color: Colors.deepPurple.shade50,
                                child: Icon(
                                  Icons.restaurant,
                                  color: Colors.deepPurple.shade200,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Recommended Item ${index + 1}",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "₹${(index + 1) * 100}.00",
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.deepPurple.shade50,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "Add to Cart",
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ));
                  },
                ),
              ),
              SizedBox(height: 30),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: ScaleTransition(
        scale: _emptyCartAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 80,
                color: Colors.deepPurple.shade300,
              ),
            ),
            SizedBox(height: 24),
            Text(
              "Your cart is empty",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 12),
            Text(
              "Add items to your cart to see them here",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponBottomSheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Text(
            "Available Coupons",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: index % 2 == 0 
                      ? Colors.deepPurple.shade50 
                      : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: index % 2 == 0 
                        ? Colors.deepPurple.shade100 
                        : Colors.orange.shade100,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              index % 2 == 0 ? Icons.local_offer : Icons.celebration,
                              color: index % 2 == 0 ? Colors.deepPurple : Colors.orange,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  index % 2 == 0 ? "FLAT${(index + 1) * 10}OFF" : "NEW${index + 1}USER",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  index % 2 == 0 
                                    ? "Save ₹${(index + 1) * 10} on your order" 
                                    : "Save ${(index + 1) * 5}% on your first order",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Coupon applied successfully!"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: index % 2 == 0 ? Colors.deepPurple : Colors.orange,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              "APPLY",
                              style: TextStyle(
                                color: index % 2 == 0 ? Colors.deepPurple : Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Valid until ${15 + index} April 2025. Min order value ₹${100 * (index + 1)}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
Widget cartItem({
  required String title,
  required String subtitle,
  required int quantity,
  required double price,
  required String imageUrl,
  required VoidCallback onAdd,
  required VoidCallback onRemove,
}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha:0.1),
          spreadRadius: 1,
          blurRadius: 5,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          // Product image with placeholder & subtle shadow
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withValues(alpha:0.08),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.deepPurple.shade50,
                  child: Icon(
                    Icons.fastfood,
                    color: Colors.deepPurple.shade200,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 16),

          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "₹$price",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.deepPurple,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 8),
                    if (price > 100)
                      Text(
                        "₹${(price * 1.2).toStringAsFixed(2)}",
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Quantity controls with smooth scaling animation
          TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 300),
            tween: Tween<double>(begin: 0.95, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: onRemove,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(
                          Icons.remove,
                          size: 18,
                          color: quantity > 1 ? Colors.deepPurple : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),

                  // Quantity with animation
                  TweenAnimationBuilder<int>(
                    duration: Duration(milliseconds: 300),
                    tween: IntTween(begin: quantity - 1, end: quantity),
                    builder: (context, value, _) => AnimatedSwitcher(
                      duration: Duration(milliseconds: 200),
                      child: Text(
                        '$value',
                        key: ValueKey<int>(value),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),

                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: onAdd,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(
                          Icons.add,
                          size: 18,
                          color: Colors.deepPurple,
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
  );
}}