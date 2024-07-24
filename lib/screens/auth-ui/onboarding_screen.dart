import 'package:e_cart/screens/auth-ui/sign-up-screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          buildPage(
            title: "Welcome to e_cart",
            description: "Your one-stop solution for online shopping.",
            imagePath: "assets/image/logo.png",
          ),
          buildPage(
            title: "Wide Range of Products",
            description: "Find everything you need in one place.",
            imagePath: "assets/image/logo.png",
          ),
          buildPage(
            title: "Easy and Secure Payments",
            description: "Experience hassle-free transactions.",
            imagePath: "assets/image/logo.png",
          ),
        ],
      ),
      bottomSheet: Container(
        height: 60,
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              // Navigate to the sign-up screen or main app screen
              Get.to(() => signupscreen());
            },
            child: Text("Get Started"),
          ),
        ),
      ),
    );
  }

  Widget buildPage({required String title, required String description, required String imagePath}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(imagePath, height: 300),
        SizedBox(height: 20),
        Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
