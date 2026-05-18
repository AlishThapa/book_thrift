import 'package:auto_route/auto_route.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/features/cart/bloc/cart_bloc.dart';
import 'package:book_thrift/features/cart/models/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final selectedItems = state.items.where((item) => item.isSelected).toList();
          final subtotal = state.totalPrice;
          const deliveryFee = 50.0;
          final total = subtotal + deliveryFee;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(title: 'Delivery Location'),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_outlined),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Main Campus Hostel, Block A', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                            Text('Room 302, Near Library', style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ),
                      TextButton(onPressed: () {}, child: const Text('Edit')),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _SectionHeader(title: 'Order Details'),
                const SizedBox(height: AppSpacing.sm),
                ...selectedItems.map((item) => _CheckoutItemTile(item: item)),
                const SizedBox(height: AppSpacing.lg),
                _SectionHeader(title: 'Order Summary'),
                const SizedBox(height: AppSpacing.sm),
                _SummaryRow(label: 'Subtotal', value: 'NPR ${subtotal.toStringAsFixed(0)}'),
                _SummaryRow(label: 'Delivery Fee', value: 'NPR ${deliveryFee.toStringAsFixed(0)}'),
                const Divider(),
                _SummaryRow(
                  label: 'Total',
                  value: 'NPR ${total.toStringAsFixed(0)}',
                  isTotal: true,
                ),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _StickyBottomButton(
        onPressed: () {
          // Process order
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order Placed Successfully!')),
          );
          context.read<CartBloc>().add(ClearCart());
          context.router.popUntilRoot();
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold));
  }
}

class _CheckoutItemTile extends StatelessWidget {
  const _CheckoutItemTile({required this.item});
  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: item.book.imagePaths.isNotEmpty
                ? Image.network(item.book.imagePaths.first, width: 50, height: 70, fit: BoxFit.cover)
                : Container(width: 50, height: 70, color: colorScheme.surfaceContainer, child: const Icon(Icons.book)),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.book.title, style: theme.textTheme.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('NPR ${item.book.sellingPrice.toStringAsFixed(0)}', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                    Text('Qty: ${item.quantity}', style: theme.textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value, this.isTotal = false});
  final String label;
  final String value;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    final style = isTotal
        ? Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
        : Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}

class _StickyBottomButton extends StatelessWidget {
  const _StickyBottomButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
            ),
            child: const Text('Confirm Order', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
