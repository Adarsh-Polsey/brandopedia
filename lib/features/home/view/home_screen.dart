import 'package:brandopedia/common/app_theme.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

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
        actions: [IconButton(style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all<Color>(AppColorpallete.secondaryColor),
          backgroundColor: WidgetStateProperty.all<Color>(AppColorpallete.primaryColor),
        ),
          onPressed: () {}, icon: Icon(Icons.person))],
      ),
      body: ListView(scrollDirection: Axis.vertical,
      children: [
        // Search TextField
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search for restaurants or dishes...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon:_searchController.text.isNotEmpty ? null : IconButton(
                          onPressed: () {
                            _searchController.clear();
                          },
                          icon: const Icon(Icons.clear),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) {
                      },
                    ),
                  ),

      ],),
    );
  }
}
