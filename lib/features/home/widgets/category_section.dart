import 'package:flutter/material.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key, required this.categories, required this.selected, required this.onTap});
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) => ChoiceChip(
          visualDensity: VisualDensity.compact,
          label: Text(categories[i]),
          selected: selected == categories[i],
          onSelected: (_) => onTap(categories[i]),
        ),
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: categories.length,
      ),
    );
  }
}
