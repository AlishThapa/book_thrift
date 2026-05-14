import 'package:auto_route/auto_route.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/core/router/app_router.gr.dart';
import 'package:book_thrift/features/cart/bloc/cart_bloc.dart';
import 'package:book_thrift/features/cart/models/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

@RoutePage()
class CartPage extends StatefulWidget {
  const CartPage({super.key, this.onNavigate});

  final ValueChanged<int>? onNavigate;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: AppSpacing.md),
          child: Center(
            child: Text(
              'My Cart',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
            ),
          ),
        ),
        leadingWidth: 100,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: SizedBox(
            height: 36,
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search in cart...',
                prefixIcon: const Icon(Icons.search, size: 18),
                filled: true,
                fillColor: colorScheme.surfaceContainerLow,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: BorderSide.none),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.read<CartBloc>().add(ClearCart()),
            icon: const Icon(Icons.delete_outline, color: Colors.black54),
            tooltip: 'Clear Cart',
          ),

          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final filteredItems = state.items.where((item) {
            return item.book.title.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

          if (state.items.isEmpty) {
            return _EmptyCartState(onNavigate: widget.onNavigate);
          }

          return Column(
            children: [
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: ListView.separated(
                  itemCount: filteredItems.length,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return _CartItemTile(item: item);
                  },
                ),
              ),
              if (state.items.any((i) => i.isSelected)) _CartBottomSection(totalPrice: state.totalPrice, isAllSelected: state.isAllSelected),
            ],
          );
        },
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Slidable(
      key: ValueKey(item.book.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        dismissible: DismissiblePane(onDismissed: () => context.read<CartBloc>().add(RemoveFromCart(item.book.id))),
        children: [
          SlidableAction(
            onPressed: (context) => context.read<CartBloc>().add(RemoveFromCart(item.book.id)),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.sm, right: AppSpacing.sm),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: item.isSelected ? colorScheme.primary.withValues(alpha: 0.2) : colorScheme.outline.withValues(alpha: 0.1)),
          boxShadow: item.isSelected
              ? [BoxShadow(color: colorScheme.primary.withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 6))]
              : [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 5, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Checkbox(
              value: item.isSelected,
              onChanged: (_) => context.read<CartBloc>().add(ToggleSelectItem(item.book.id)),
              visualDensity: VisualDensity.compact,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: item.book.imagePaths.isNotEmpty
                  ? Image.network(item.book.imagePaths.first, width: 60, height: 80, fit: BoxFit.cover)
                  : Container(width: 60, height: 80, color: colorScheme.surfaceContainer, child: const Icon(Icons.book, size: 30)),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.book.title,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'NPR ${item.book.sellingPrice.toStringAsFixed(0)}',
                        style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          _QtyBtn(icon: Icons.remove, onTap: () => context.read<CartBloc>().add(UpdateQuantity(item.book.id, item.quantity - 1))),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text('${item.quantity}', style: theme.textTheme.bodySmall),
                          ),
                          _QtyBtn(icon: Icons.add, onTap: () => context.read<CartBloc>().add(UpdateQuantity(item.book.id, item.quantity + 1))),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  const _QtyBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}

class _CartBottomSection extends StatelessWidget {
  const _CartBottomSection({required this.totalPrice, required this.isAllSelected});

  final double totalPrice;
  final bool isAllSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Row(
              children: [
                Checkbox(value: isAllSelected, onChanged: (val) => context.read<CartBloc>().add(ToggleSelectAll(val ?? false))),
                const Text('All'),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Total', style: TextStyle(fontSize: 12)),
                Text(
                  'NPR ${totalPrice.toStringAsFixed(0)}',
                  style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.md),
            ElevatedButton(
              onPressed: () => context.router.push(const CheckoutRoute()),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
              ),
              child: const Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCartState extends StatelessWidget {
  const _EmptyCartState({this.onNavigate});

  final ValueChanged<int>? onNavigate;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(color: colorScheme.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(Icons.shopping_cart_outlined, size: 64, color: colorScheme.primary),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Your cart is empty', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Looks like you haven\'t added any\nbooks to your cart yet.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton(
            onPressed: () {
              if (onNavigate != null) {
                onNavigate!(0); // Go to Home
              } else {
                context.router.popUntilRoot();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
            ),
            child: const Text('Start Shopping'),
          ),
        ],
      ),
    );
  }
}
