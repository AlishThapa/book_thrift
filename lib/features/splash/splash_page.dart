import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:book_thrift/constants/font_sizes.dart';
import 'package:book_thrift/core/router/app_router.gr.dart';

@RoutePage()
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
      context.router.replace(const OnboardingRoute());
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
            Text('KitabSathi', style: TextStyle(fontSize: FontSizes.xxl, fontWeight: FontWeight.w700)),
            SizedBox(height: 8),
            Text('Buy. Sell. Learn Locally.'),
          ],
        ),
      ),
    );
  }
}
