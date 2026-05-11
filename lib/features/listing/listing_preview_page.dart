import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/constants/widgets/app_surface.dart';
import 'package:book_thrift/features/listing/bloc/create_listing_bloc.dart';
import 'package:book_thrift/shared/widgets/system/bottom_cta_bar.dart';

class ListingPreviewPage extends StatelessWidget {
  const ListingPreviewPage({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.where((e) => e.value.toString().trim().isNotEmpty).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Listing Preview')),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: entries.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
        itemBuilder: (_, i) => AppSurface(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(_toLabel(entries[i].key), style: AppTextStyles.cardTitle),
            subtitle: Text(entries[i].value.toString(), style: AppTextStyles.subtitle),
          ),
        ),
      ),
      bottomNavigationBar: BottomCtaBar(
        children: [
          Expanded(
            child: FilledButton(
              onPressed: () {
                context.read<CreateListingBloc>().add(PublishListing());
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Publish'),
            ),
          ),
        ],
      ),
    );
  }

  String _toLabel(String key) {
    final withSpaces = key.replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m.group(1)}');
    return '${withSpaces[0].toUpperCase()}${withSpaces.substring(1)}';
  }
}
