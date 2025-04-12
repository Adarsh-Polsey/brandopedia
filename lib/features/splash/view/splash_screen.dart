import 'package:brandopedia/common/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorpallete.primaryColor,
      body: Center(
        // Brandopedia logo + name
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
        // Brandopedia logo
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColorpallete.secondaryColor,
              ),
              child: const Padding(
                padding: EdgeInsets.all(30.0),
                child: Text(
                  "B",
                  style: TextStyle(
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                    color: AppColorpallete.primaryColor,
                  ),
                ),
              ),
            ),
        // Brandopedia name
            AnimatedTextKit(onFinished: () => Navigator.pushReplacementNamed(context, '/nav'),
            totalRepeatCount: 1,
              animatedTexts: [
                ColorizeAnimatedText(
                  "TheBrandopedia",
                  textStyle: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: AppColorpallete.secondaryColor,
                  ),
                  speed: const Duration(milliseconds: 270),
                  colors: [
                    AppColorpallete.secondaryColor,
                    AppColorpallete.primaryColor,
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
