import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/authController.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/1.jpg",
      "title": "Welcome\nto\nConnect India Enterprises",
      "desc":
          "Empowering businesses with smart financial and operational solutions."
    },
    {
      "image": "assets/images/2.jpg",
      "title": "Simplify Your Workflow with us.",
      "desc":
          "Manage investments, insurance, loans, and policies—all from one powerful platform trusted by growing Indian businesses. Join Connect India Enterprises and take control with ease."
    },
    {
      "image": "assets/images/3.jpg",
      "title": "Accelerate Financial Growth with us.",
      "desc":
          "Leverage powerful financial solutions to manage cash flow, optimize investments, and drive profitability. Partner with Connect India Enterprises to build a secure and scalable financial future",
    },
    {
      "image": "assets/images/4.jpg",
      "title": "Start Your Journey",
      "desc":
          "Join the Connect India Enterprises network and digitize your financial ecosystem today."
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkIfOnboarded();
  }

  Future<void> _checkIfOnboarded() async {
    final prefs = await SharedPreferences.getInstance();
    final isOnboarded = prefs.getBool('isOnboarded') ?? false;

    // Skip onboarding only if user has already completed it
    if (isOnboarded) {
      AuthController.checkLoginStatus(context);
    }
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnboarded', true);
    AuthController.checkLoginStatus(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        controller: _controller,
        itemCount: onboardingData.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final isLast = index == onboardingData.length - 1;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 80),
                    Image.asset(onboardingData[index]['image']!, height: 300),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      onboardingData[index]['title']!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    Text(
                      onboardingData[index]['desc']!,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => _completeOnboarding(),
                      child: const Text("Skip"),
                    ),
                    Row(
                      children:
                          List.generate(onboardingData.length, (dotIndex) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: currentIndex == dotIndex ? 10 : 6,
                          height: currentIndex == dotIndex ? 10 : 6,
                          decoration: BoxDecoration(
                            color: currentIndex == dotIndex
                                ? Colors.orange
                                : Colors.grey.shade300,
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                    ),
                    TextButton(
                      onPressed: () {
                        final isLast =
                            currentIndex == onboardingData.length - 1;
                        if (isLast) {
                          _completeOnboarding();
                        } else {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Text(currentIndex == onboardingData.length - 1
                          ? "Done"
                          : "Next"),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
