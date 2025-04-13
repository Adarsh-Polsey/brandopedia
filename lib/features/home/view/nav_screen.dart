import 'dart:ui';

import 'package:brandopedia/common/app_theme.dart';
import 'package:brandopedia/features/cart/view/cart_screen.dart';
import 'package:brandopedia/features/home/view/home_screen.dart';
import 'package:brandopedia/features/profile/view/profile_screen.dart';
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
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      bottomNavigationBar: ClipRRect(
  borderRadius: BorderRadius.vertical(top:Radius.circular(16)),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
    child: Container(
      decoration: BoxDecoration(
        color: AppColorpallete.secondaryColor.withValues(alpha:0.1),
        border: Border.all(
          color: Colors.white.withValues(alpha:0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical:15,horizontal: 30),
      child:GNav(
          backgroundColor: Colors.transparent,
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          rippleColor: Colors.transparent,
          hoverColor: Colors.transparent,
          haptic: true,
          curve: Curves.easeInOutCubic,
          duration: const Duration(milliseconds: 500),
          gap: 8,
          color: Colors.grey[800],
          activeColor: AppColorpallete.primaryColor,
          iconSize: 24,
          tabBackgroundColor: AppColorpallete.primaryColor.withValues(
            alpha: 0.1,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          tabs: const [
            GButton(icon: Icons.home_outlined, text: 'Home'),
            GButton(icon: Icons.shopping_cart_outlined, text: 'Cart'),
            GButton(icon: Icons.person_outline, text: 'Profile'),
          ],
        ),
      ),
    )));
  }
}
