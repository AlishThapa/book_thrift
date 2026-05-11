import 'package:flutter/material.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/core/data/app_repository.dart';
import 'package:book_thrift/core/di/injection.dart';
import 'package:book_thrift/features/listing/book_detail_page.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';
import 'package:book_thrift/shared/widgets/book_card.dart';
import 'package:book_thrift/shared/widgets/system/app_filter_chip.dart';

class CategoryListingPage extends StatefulWidget {
  const CategoryListingPage({super.key, required this.category});
  final String category;

  @override
  State<CategoryListingPage> createState() => _CategoryListingPageState();
}

class _CategoryListingPageState extends State<CategoryListingPage> {
  bool grid = false;
  List<BookListing> items = [];

  @override
  void initState() {
    super.initState();
    getIt<AppRepository>().listings().then((v) => setState(() => items = v.where((e) => e.category == widget.category).toList()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        actions: [IconButton(onPressed: () => setState(() => grid = !grid), icon: Icon(grid ? Icons.view_list : Icons.grid_view))],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Text('${items.length} results', style: AppTextStyles.subtitle),
                const Spacer(),
                AppFilterChip(label: 'Filter', selected: false, onSelected: (_) {}),
                const SizedBox(width: AppSpacing.xs),
                AppFilterChip(label: 'Sort', selected: false, onSelected: (_) {}),
              ],
            ),
          ),
          Expanded(
            child: grid
                ? GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 0.7),
                    itemCount: items.length,
                    itemBuilder: (_, i) => BookCard(listing: items[i], grid: true, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookDetailPage(listing: items[i])))),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
                    itemBuilder: (_, i) => BookCard(listing: items[i], onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookDetailPage(listing: items[i])))),
                  ),
          ),
        ],
      ),
    );
  }
}
