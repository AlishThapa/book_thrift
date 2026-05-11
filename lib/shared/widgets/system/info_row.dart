import 'package:flutter/material.dart';
import 'package:book_thrift/constants/design_tokens.dart';

class InfoRow extends StatelessWidget {
  const InfoRow({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.black54),
          const SizedBox(width: AppSpacing.xs),
          Expanded(child: Text(label, style: AppTextStyles.subtitle)),
        ],
      ),
    );
  }
}
