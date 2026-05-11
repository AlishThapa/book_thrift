import 'dart:async';

import 'package:flutter/material.dart';
import 'package:book_thrift/constants/font_sizes.dart';
import 'package:book_thrift/features/onboarding/onboarding_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OnboardingPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_rounded, size: 72),
            SizedBox(height: 12),
            Text('BookLoop', style: TextStyle(fontSize: FontSizes.xxl, fontWeight: FontWeight.w700)),
            SizedBox(height: 8),
            Text('Buy. Sell. Learn Locally.'),
          ],
        ),
      ),
    );
  }
}
