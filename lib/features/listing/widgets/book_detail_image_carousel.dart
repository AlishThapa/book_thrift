import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:book_thrift/constants/design_tokens.dart';

class BookDetailImageCarousel extends StatefulWidget {
  const BookDetailImageCarousel({
    super.key,
    required this.imagePaths,
    required this.listingId,
    this.heroTag,
  });

  final List<String> imagePaths;
  final String listingId;
  final String? heroTag;

  @override
  State<BookDetailImageCarousel> createState() => _BookDetailImageCarouselState();
}

class _BookDetailImageCarouselState extends State<BookDetailImageCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.heroTag ?? 'book_image_${widget.listingId}',
      child: Material(
        color: Colors.transparent,
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    final colorScheme = Theme.of(context).colorScheme;

    if (widget.imagePaths.isEmpty) {
      return Container(
        color: colorScheme.primary.withValues(alpha: 0.05),
        child: Center(
          child: Icon(Icons.auto_stories_rounded, size: 80, color: colorScheme.primary),
        ),
      );
    }

    return Stack(
      children: [
        PageView.builder(
          itemCount: widget.imagePaths.length,
          onPageChanged: (index) => setState(() => _currentIndex = index),
          itemBuilder: (context, index) {
            final path = widget.imagePaths[index];
            final isNetwork = path.startsWith('http');

            if (isNetwork) {
              return CachedNetworkImage(
                imageUrl: path,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: colorScheme.surfaceContainerHigh,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: colorScheme.surfaceContainerHigh,
                  child: Icon(Icons.error_outline_rounded, color: colorScheme.error),
                ),
              );
            } else {
              return Image.file(
                File(path),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: colorScheme.surfaceContainerHigh,
                  child: Icon(Icons.error_outline_rounded, color: colorScheme.error),
                ),
              );
            }
          },
        ),
        if (widget.imagePaths.length > 1)
          Positioned(
            bottom: AppSpacing.md,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.imagePaths.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _currentIndex == index ? 24 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _currentIndex == index
                        ? colorScheme.primary
                        : Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
