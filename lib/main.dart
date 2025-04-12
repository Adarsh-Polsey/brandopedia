import 'package:brandopedia/common/app_theme.dart';
import 'package:brandopedia/features/cart/view/cart_screen.dart';
import 'package:brandopedia/features/cart/viewmodel/cart_viewmodel.dart';
import 'package:brandopedia/features/home/view/home_screen.dart';
import 'package:brandopedia/features/home/viewmodel/home_viewmodel.dart';
import 'package:brandopedia/features/splash/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartViewModel()),
        ChangeNotifierProvider(create: (context) => HomeViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Brandopedia',
      theme: AppTheme.themeData,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/cart': (context) =>  const CartScreen(),
      },
      );
  }
}