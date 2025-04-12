import 'package:brandopedia/common/app_theme.dart';
import 'package:brandopedia/features/cart/view/cart_screen.dart';
import 'package:brandopedia/features/home/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    CartScreen(),
    Center(child: Text("Profile Screen")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: GNav(
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          rippleColor: Colors.grey.shade300,
          hoverColor: Colors.grey.shade100,
          haptic: true,
          tabBorderRadius: 15,
          tabActiveBorder: Border.all(color: Colors.black, width: 1),
          tabBorder: Border.all(color: Colors.grey.shade300, width: 1),
          tabShadow: [
            BoxShadow(color: Colors.grey.withValues(alpha:0.2), blurRadius: 8)
          ],
          curve: Curves.easeOutExpo,
          duration: const Duration(milliseconds: 500),
          gap: 8,
          color: Colors.grey[800],
          activeColor: AppColorpallete.primaryColor,
          iconSize: 24,
          tabBackgroundColor: AppColorpallete.primaryColor.withValues(alpha:0.1),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          tabs: const [
            GButton(icon: Icons.home_outlined, text: 'Home'),
            GButton(icon: Icons.shopping_cart_outlined, text: 'Cart'),
            GButton(icon: Icons.person_outline, text: 'Profile'),
          ],
        ),
      ),
    );
  }
}