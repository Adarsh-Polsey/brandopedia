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
                gradient: RadialGradient(radius: 2.6,
                  colors: [
                    AppColorpallete.secondaryColor,
                    AppColorpallete.primaryColor,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColorpallete.secondaryColor.withValues(alpha:0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: AnimatedTextKit(
                  pause: Duration(milliseconds: 0),
                  onFinished: () => Navigator.pushReplacementNamed(context, '/nav'),
                  totalRepeatCount: 1,
                  animatedTexts: [
                    ColorizeAnimatedText(
                      "TheBrandopedia",
                      textStyle: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: AppColorpallete.secondaryColor,
                      ),
                      speed: const Duration(milliseconds: 170),
                      colors: [
                        AppColorpallete.secondaryColor,
                        AppColorpallete.primaryColor,
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
