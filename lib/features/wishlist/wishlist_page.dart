import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/core/data/app_repository.dart';
import 'package:book_thrift/core/di/injection.dart';
import 'package:book_thrift/features/listing/book_detail_page.dart';
import 'package:book_thrift/features/wishlist/bloc/wishlist_bloc.dart';
import 'package:book_thrift/shared/widgets/book_card.dart';
import 'package:book_thrift/core/router/app_router.gr.dart';

@RoutePage()
class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: BlocBuilder<WishlistBloc, WishlistState>(builder: (context, state) {
        return FutureBuilder(
          future: getIt<AppRepository>().listings(),
          builder: (_, snapshot) {
            final all = snapshot.data ?? [];
            final list = all.where((e) => state.ids.contains(e.id)).toList();
            if (list.isEmpty) {
              return const Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.favorite_border, size: 48),
                  SizedBox(height: 8),
                  Text('Your wishlist is empty'),
                ]),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
              itemBuilder: (_, i) => Dismissible(
                key: ValueKey(list[i].id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(color: Colors.red.shade400, borderRadius: BorderRadius.circular(16)),
                  child: const Icon(Icons.delete_outline, color: Colors.white),
                ),
                onDismissed: (_) => context.read<WishlistBloc>().add(ToggleWishlist(list[i].id)),
                child: BookCard(
                  listing: list[i],
                  onTap: () => context.router.push(BookDetailRoute(listing: list[i])),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () => context.read<WishlistBloc>().add(ToggleWishlist(list[i].id)),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
