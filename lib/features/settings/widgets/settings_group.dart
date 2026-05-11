import 'package:flutter/material.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/constants/size_constants.dart';
import 'package:book_thrift/constants/widgets/app_surface.dart';

import '../../../constants/app_colors.dart';

class SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsGroup({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.xs, bottom: AppSpacing.xs),
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        AppSurface(
          padding: EdgeInsets.zero,
          child: Column(
            children: _buildChildrenWithDividers(),
          ),
        ),
        const SizedBox(height: HeightConstants.lg),
      ],
    );
  }

  List<Widget> _buildChildrenWithDividers() {
    if (children.isEmpty) return [];
    
    final List<Widget> result = [];
    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(const Divider(height: 1, indent: AppSpacing.md, endIndent: AppSpacing.md));
      }
    }
    return result;
  }
}
