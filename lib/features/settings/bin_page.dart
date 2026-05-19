import 'package:auto_route/auto_route.dart';
import 'package:book_thrift/constants/app_colors.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/features/settings/bloc/bin_bloc.dart';
import 'package:book_thrift/shared/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class BinPage extends StatefulWidget {
  const BinPage({super.key});

  @override
  State<BinPage> createState() => _BinPageState();
}

class _BinPageState extends State<BinPage> {
  int _animationSession = 0;

  @override
  void initState() {
    super.initState();
    context.read<BinBloc>().add(FetchBin());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bin'),
        centerTitle: true,
        actions: [
          BlocBuilder<BinBloc, BinState>(
            builder: (context, state) {
              if (state.books.isEmpty) return const SizedBox.shrink();
              return PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'recover_all') {
                    _showRecoverAllConfirmation(context);
                  } else if (value == 'delete_all') {
                    _showDeleteAllConfirmation(context);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'recover_all',
                    child: Row(
                      children: [
                        Icon(Icons.restore_rounded, color: AppColors.success, size: 20),
                        SizedBox(width: AppSpacing.sm),
                        Text('Recover All', style: TextStyle(color: AppColors.success)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete_all',
                    child: Row(
                      children: [
                        Icon(Icons.delete_forever_rounded, color: AppColors.error, size: 20),
                        SizedBox(width: AppSpacing.sm),
                        Text('Delete All', style: TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<BinBloc, BinState>(
        listener: (context, state) {
          if (state.status == BinStatus.loading && state.books.isEmpty) {
            setState(() {
              _animationSession++;
            });
          }
          if (state.status == BinStatus.failure && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!), behavior: SnackBarBehavior.floating),
            );
          }
        },
        builder: (context, state) {
          if (state.status == BinStatus.loading && state.books.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.books.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete_outline_rounded, size: 64, color: AppColors.neutral.withValues(alpha: 0.5)),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Your bin is empty',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<BinBloc>().add(FetchBin());
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: state.books.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final book = state.books[index];
                return _AnimatedBinCard(
                  key: ValueKey('bin_anim_${_animationSession}_${book.id}'),
                  index: index,
                  child: Column(
                    children: [
                      BookCard(listing: book),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _showRecoverConfirmation(context, book.id),
                              icon: const Icon(Icons.restore_rounded, size: 18),
                              label: const Text('Recover'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: const BorderSide(color: AppColors.primary),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _showDeleteConfirmation(context, book.id),
                              icon: const Icon(Icons.delete_forever_rounded, size: 18),
                              label: const Text('Delete'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.error,
                                side: const BorderSide(color: AppColors.error),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showRecoverConfirmation(BuildContext context, String bookId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recover Book?'),
        content: const Text('Are you sure you want to recover this book? It will be moved back to your active listings.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              this.context.read<BinBloc>().add(RecoverBook(bookId));
            },
            child: const Text('Recover'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String bookId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permanently Delete?'),
        content: const Text('This action is permanent and cannot be undone. Are you sure?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              this.context.read<BinBloc>().add(PermanentlyDeleteBook(bookId));
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _showRecoverAllConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recover All Books?'),
        content: const Text('Are you sure you want to recover all books from the bin?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              this.context.read<BinBloc>().add(RecoverAllBooks());
            },
            child: const Text('Recover All'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permanently Delete All?'),
        content: const Text('This will permanently delete all books in your bin. This action cannot be undone. Are you sure?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              this.context.read<BinBloc>().add(DeleteAllBooks());
            },
            child: const Text('Delete All', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _AnimatedBinCard extends StatefulWidget {
  final Widget child;
  final int index;

  const _AnimatedBinCard({super.key, required this.child, required this.index});

  @override
  State<_AnimatedBinCard> createState() => _AnimatedBinCardState();
}

class _AnimatedBinCardState extends State<_AnimatedBinCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.1, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    final delay = widget.index < 6 ? Duration(milliseconds: widget.index * 80) : Duration.zero;

    Future.delayed(delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}
