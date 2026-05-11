import 'package:flutter/material.dart';
import 'package:book_thrift/constants/design_tokens.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        margin: const EdgeInsets.only(top: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _statItem(context, '12', 'Listings', Icons.book_outlined),
            _divider(context),
            _statItem(context, '4.8', 'Rating', Icons.star_rounded),
            _divider(context),
            _statItem(context, '24', 'Sold', Icons.shopping_cart_outlined),
          ],
        ),
      ),
    );
  }

  Widget _divider(BuildContext context) => Container(
        height: 24,
        width: 1,
        color: Theme.of(context).colorScheme.outline,
      );

  Widget _statItem(BuildContext context, String value, String label, IconData icon) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              value,
              style: textTheme.titleMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(fontSize: 11),
        ),
      ],
    );
  }
}
