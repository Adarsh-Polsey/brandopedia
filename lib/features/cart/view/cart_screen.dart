import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int quickBitesQuantity = 1;
  int margheritaPizzaQuantity = 1;
  int gulabJamunQuantity = 1;

  @override
  Widget build(BuildContext context) {
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
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.grey),
            onPressed: () {
              // Clear cart functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
                    child: Text(
                      "${getTotalItems()} items in your cart",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      cartItem(
                        title: "Quick Bites",
                        subtitle: "Delicious quick bites",
                        quantity: quickBitesQuantity,
                        price: 150,
                        imageUrl: "https://via.placeholder.com/80",
                        onAdd: () => setState(() => quickBitesQuantity++),
                        onRemove: () => setState(() {
                          if (quickBitesQuantity > 0) quickBitesQuantity--;
                        }),
                      ),
                      cartItem(
                        title: "Margherita Pizza",
                        subtitle: "Classic cheese pizza",
                        quantity: margheritaPizzaQuantity,
                        price: 300,
                        imageUrl: "https://via.placeholder.com/80",
                        onAdd: () => setState(() => margheritaPizzaQuantity++),
                        onRemove: () => setState(() {
                          if (margheritaPizzaQuantity > 0) margheritaPizzaQuantity--;
                        }),
                      ),
                      cartItem(
                        title: "Gulab Jamun",
                        subtitle: "Sweet dessert",
                        quantity: gulabJamunQuantity,
                        price: 50,
                        imageUrl: "https://via.placeholder.com/80",
                        onAdd: () => setState(() => gulabJamunQuantity--),
                        onRemove: () => setState(() {
                          if (gulabJamunQuantity > 0) gulabJamunQuantity--;
                        }),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Coupon section
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.local_offer, color: Colors.deepPurple),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            "Apply Coupon Code",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Order summary
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Subtotal",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      "₹${totalAmount() - 40}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
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
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      "₹40",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
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
                    Text(
                      "₹${totalAmount()}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Checkout",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
            color: Colors.grey.withOpacity(0.1),
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
            // Food image
            ClipRRect(
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
            SizedBox(width: 16),
            
            // Food details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "₹$price",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
            ),
            
            // Quantity controls
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  IconButton(
                    constraints: BoxConstraints(minWidth: 36, minHeight: 36),
                    icon: Icon(Icons.remove, size: 18),
                    color: quantity > 1 ? Colors.deepPurple : Colors.grey,
                    onPressed: onRemove,
                  ),
                  Text(
                    quantity.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    constraints: BoxConstraints(minWidth: 36, minHeight: 36),
                    icon: Icon(Icons.add, size: 18),
                    color: Colors.deepPurple,
                    onPressed: onAdd,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double totalAmount() {
    return (quickBitesQuantity * 150) + (margheritaPizzaQuantity * 300) + (gulabJamunQuantity * 50) + 40; // Adding delivery fee
  }
  
  int getTotalItems() {
    return quickBitesQuantity + margheritaPizzaQuantity + gulabJamunQuantity;
  }
}