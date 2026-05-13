import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/constants/size_constants.dart';
import 'package:book_thrift/constants/widgets/app_surface.dart';

@RoutePage()
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About KitabSathi'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  const SizedBox(height: HeightConstants.sm),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.menu_book_rounded, size: 64, color: colorScheme.primary),
                  ),
                  const SizedBox(height: HeightConstants.md),
                  Text(
                    'KitabSathi',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version 1.0.0 (Build 1)',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: HeightConstants.sm),
                ],
              ),
            ),
            const SizedBox(height: HeightConstants.lg),
            
            _buildSection(
              context,
              title: 'Our Mission',
              content: 'KitabSathi is a community-driven platform designed to make education more accessible and affordable. We believe that every student should have access to the books they need without breaking the bank.',
            ),
            
            const SizedBox(height: HeightConstants.lg),
            
            _buildSection(
              context,
              title: 'What we do',
              content: 'We provide a marketplace for students and book lovers to buy, sell, or exchange their used books locally. By facilitating direct connections between buyers and sellers, we eliminate unnecessary costs and promote a sustainable cycle of learning.',
            ),
            
            const SizedBox(height: HeightConstants.lg),
            
            _buildSection(
              context,
              title: 'Key Features',
              child: const Column(
                children: [
                  BulletPoint(text: 'Browse and search for textbooks and other literature.'),
                  BulletPoint(text: 'List your own books for sale or giveaway in minutes.'),
                  BulletPoint(text: 'Chat directly with buyers and sellers.'),
                  BulletPoint(text: 'Join a local community of learners.'),
                ],
              ),
            ),
            
            const SizedBox(height: HeightConstants.xl),
            Center(
              child: Text(
                '© ${DateTime.now().year} KitabSathi Team',
                style: AppTextStyles.caption.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
            const SizedBox(height: HeightConstants.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, String? content, Widget? child}) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.xs, bottom: AppSpacing.xs),
          child: Text(
            title.toUpperCase(),
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        AppSurface(
          child: child ?? Text(
            content!,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ),
      ],
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;
  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline_rounded, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
