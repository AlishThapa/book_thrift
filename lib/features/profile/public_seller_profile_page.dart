import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:book_thrift/constants/widgets/app_surface.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/constants/app_colors.dart';

@RoutePage()
class PublicSellerProfilePage extends StatelessWidget {
  const PublicSellerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('Seller Profile'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        children: [
          const SizedBox(height: AppSpacing.md),
          _buildProfileHeader(context),
          const SizedBox(height: AppSpacing.xl),
          _buildStatsSection(context),
          const SizedBox(height: AppSpacing.xl),
          _buildSectionTitle(context, 'About Seller'),
          const SizedBox(height: AppSpacing.sm),
          AppSurface(
            child: Text(
              'Verified student seller from the Main Campus Area. Highly rated for prompt responses and well-maintained books.',
              style: textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildSectionTitle(context, 'Recent Activity'),
          const SizedBox(height: AppSpacing.sm),
          AppSurface(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(Icons.history_rounded, color: colorScheme.primary),
              ),
              title: const Text('Last active'),
              trailing: Text(
                '2 hours ago',
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.4),
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: colorScheme.primary,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.surfaceContainerLowest,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.verified_rounded,
                size: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Local Student Seller',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 14,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              'Joined Jan 2025 • Campus Area',
              style: textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            '4.5',
            'Rating',
            Icons.star_rounded,
            Colors.orange,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildStatCard(
            context,
            '12',
            'Active',
            Icons.menu_book_rounded,
            colorScheme.primary,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildStatCard(
            context,
            '39',
            'Sold',
            Icons.shopping_bag_rounded,
            AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color iconColor,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return AppSurface(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface, // Ensures readability in dark mode
            ),
          ),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
