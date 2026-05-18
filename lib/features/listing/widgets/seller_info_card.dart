import 'package:book_thrift/features/auth/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:book_thrift/constants/design_tokens.dart';

class SellerInfoCard extends StatelessWidget {
  const SellerInfoCard({
    super.key,
    this.owner,
    this.onTap,
  });

  final UserProfile? owner;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final name = owner?.fullName ?? 'Local Student';
    final phone = owner?.phone ?? '';
    final email = owner?.email ?? '';
    final institution = owner?.institutionName ?? '';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                backgroundImage: owner?.imagePath != null ? NetworkImage(owner!.imagePath!) : null,
                child: owner?.imagePath == null
                    ? Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (institution.isNotEmpty)
                      Text(
                        institution,
                        style: textTheme.bodySmall?.copyWith(color: colorScheme.primary),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.md),
          _InfoRow(icon: Icons.phone_outlined, text: phone.isEmpty ? 'Not provided' : phone),
          const SizedBox(height: AppSpacing.sm),
          _InfoRow(icon: Icons.email_outlined, text: email.isEmpty ? 'Not provided' : email),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ),
      ],
    );
  }
}
