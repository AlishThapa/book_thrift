import 'package:flutter/material.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';

class BookSpecsGrid extends StatelessWidget {
  const BookSpecsGrid({super.key, required this.listing});
  final BookListing listing;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      padding: EdgeInsets.zero,
      mainAxisSpacing: AppSpacing.sm,
      crossAxisSpacing: AppSpacing.sm,
      children: [
        _SpecTile(
          icon: Icons.category_outlined,
          label: 'Category',
          value: listing.category,
        ),
        _SpecTile(
          icon: Icons.verified_outlined,
          label: 'Condition',
          value: listing.condition,
        ),
        _SpecTile(
          icon: Icons.location_on_outlined,
          label: 'Location',
          value: listing.location,
        ),
        _SpecTile(
          icon: Icons.inventory_2_outlined,
          label: 'Quantity',
          value: listing.quantity.toString(),
        ),
      ],
    );
  }
}

class _SpecTile extends StatelessWidget {
  const _SpecTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isEmpty = value.trim().isEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: textTheme.bodySmall?.copyWith(fontSize: 10),
                ),
                Text(
                  isEmpty ? 'N/A' : value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: isEmpty ? FontWeight.normal : FontWeight.bold,
                    color: isEmpty ? colorScheme.onSurfaceVariant : colorScheme.onSurface,
                    fontStyle: isEmpty ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
