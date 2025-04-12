import 'package:flutter/material.dart';

class FoodItemCard extends StatefulWidget {
  final Map<String, dynamic> item;
  const FoodItemCard({super.key, required this.item});

  @override
  State<FoodItemCard> createState() => _FoodItemCardState();
}

class _FoodItemCardState extends State<FoodItemCard> {
  late bool isFavourite;
  late bool inCart;

  @override
  void initState() {
    super.initState();
    isFavourite = widget.item['isFavourite'] ?? false;
    inCart = widget.item['inCart'] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Container(
      height: 140,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left side - Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
                child: Image.network(
                  item["imageUrl"],
                  height: 140,
                  width: 140,
                  fit: BoxFit.cover,
                ),
              ),
              // Favorite icon
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isFavourite = !isFavourite;
                    });
                  },
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white.withOpacity(0.9),
                    child: Icon(
                      isFavourite ? Icons.favorite : Icons.favorite_border,
                      color: isFavourite ? Colors.red : Colors.grey,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Right side - Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Name and Category
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item["name"],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item["category"],
                          style: TextStyle(fontSize: 10, color: Colors.orange),
                        ),
                      ),
                    ],
                  ),

                  // Description
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        item["description"],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  // Price, Rating and Cart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      Text(
                        "₹${item["price"]}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[700],
                        ),
                      ),
                      
                      // Rating
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          SizedBox(width: 2),
                          Text(
                            "${item["rating"]}",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),

                      // Cart Icon
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            inCart = !inCart;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            inCart ? Icons.shopping_cart : Icons.add_shopping_cart,
                            color: Colors.green.shade800,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}