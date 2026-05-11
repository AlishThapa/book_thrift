import 'package:flutter/material.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/constants/widgets/app_surface.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.meta,
    required this.onEdit,
    this.imagePath,
  });

  final String name;
  final String subtitle;
  final String meta;
  final String? imagePath;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: (imagePath != null && imagePath!.trim().isNotEmpty) ? NetworkImage(imagePath!.trim()) : null,
            child: (imagePath == null || imagePath!.trim().isEmpty) ? const Icon(Icons.person, size: 28) : null,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(name, style: AppTextStyles.sectionTitle),
          Text(subtitle, style: AppTextStyles.subtitle, textAlign: TextAlign.center),
          const SizedBox(height: 2),
          Text(meta, style: AppTextStyles.caption),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(width: double.infinity, child: OutlinedButton(onPressed: onEdit, child: const Text('Edit profile'))),
        ],
      ),
    );
  }
}
