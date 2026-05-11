import 'package:flutter/material.dart';
import 'package:book_thrift/constants/app_colors.dart';

/// Animated shimmer placeholder shown while book listings load.
class BookCardSkeleton extends StatefulWidget {
  const BookCardSkeleton({super.key});

  @override
  State<BookCardSkeleton> createState() => _BookCardSkeletonState();
}

class _BookCardSkeletonState extends State<BookCardSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.4, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => Opacity(
        opacity: _animation.value,
        child: Container(
          width: 170,
          decoration: BoxDecoration(
            color: AppColors.neutralLight,
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover placeholder
              Container(
                height: 110,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.neutral.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 10),
              // Title line 1
              _ShimmerLine(width: double.infinity, height: 12),
              const SizedBox(height: 6),
              // Title line 2
              _ShimmerLine(width: 100, height: 12),
              const SizedBox(height: 8),
              // Condition badge
              _ShimmerLine(width: 60, height: 10),
              const Spacer(),
              // Price
              _ShimmerLine(width: 50, height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShimmerLine extends StatelessWidget {
  const _ShimmerLine({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.neutral.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}