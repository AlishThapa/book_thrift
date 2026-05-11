import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/constants/widgets/app_surface.dart';
import 'package:book_thrift/core/data/app_repository.dart';
import 'package:book_thrift/core/di/injection.dart';
import 'package:book_thrift/features/notifications/models/app_notification.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  Key _refreshKey = UniqueKey();

  void _refresh() => setState(() => _refreshKey = UniqueKey());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      body: CustomScrollView(
        key: _refreshKey,
        slivers: [
          _buildHeader(context),
          FutureBuilder<List<AppNotification>>(
            future: getIt<AppRepository>().notifications(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final items = snapshot.data ?? [];
              if (items.isEmpty) {
                return SliverFillRemaining(child: _buildEmptyState(context));
              }

              // Sort by date newest first
              items.sort((a, b) => b.createdAt.compareTo(a.createdAt));

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(_groupNotifications(context, items)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorScheme.primary, colorScheme.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          'Notifications',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _refresh(),
                        icon: const Icon(Icons.done_all_rounded, color: Colors.white),
                        tooltip: 'Read All',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _groupNotifications(BuildContext context, List<AppNotification> items) {
    final List<Widget> widgets = [];
    final now = DateTime.now();

    final today = items.where((i) => _isSameDay(i.createdAt, now)).toList();
    final yesterday = items.where((i) => _isSameDay(i.createdAt, now.subtract(const Duration(days: 1)))).toList();
    final older = items.where((i) => !today.contains(i) && !yesterday.contains(i)).toList();

    if (today.isNotEmpty) {
      widgets.add(_sectionTitle(context, 'Today'));
      widgets.addAll(today.map((i) => _NotificationTile(notification: i, onDismissed: _refresh)));
    }

    if (yesterday.isNotEmpty) {
      widgets.add(_sectionTitle(context, 'Yesterday'));
      widgets.addAll(yesterday.map((i) => _NotificationTile(notification: i, onDismissed: _refresh)));
    }

    if (older.isNotEmpty) {
      widgets.add(_sectionTitle(context, 'Earlier'));
      widgets.addAll(older.map((i) => _NotificationTile(notification: i, onDismissed: _refresh)));
    }

    return widgets;
  }

  Widget _sectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.sm, left: 4),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: 1.1,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              size: 80,
              color: colorScheme.primary.withValues(alpha: 0.15),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'All caught up!',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Your notifications will live here.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification, required this.onDismissed});

  final AppNotification notification;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final timeFormat = DateFormat('h:mm a');

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        decoration: BoxDecoration(
          color: colorScheme.error,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: const Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 28),
      ),
      onDismissed: (_) {
        // repo.deleteNotification(notification.id);
        onDismissed();
      },
      child: AppSurface(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLeadingIcon(context),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: textTheme.titleMedium?.copyWith(
                            fontSize: 15,
                            color: notification.isRead ? colorScheme.onSurfaceVariant : colorScheme.onSurface,
                            fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        timeFormat.format(notification.createdAt),
                        style: textTheme.bodySmall?.copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body,
                    style: textTheme.bodyMedium?.copyWith(
                      fontSize: 13,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (!notification.isRead)
              Container(
                margin: const EdgeInsets.only(left: AppSpacing.sm, top: 4),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadingIcon(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    IconData icon = Icons.notifications_none_rounded;
    Color color = colorScheme.primary;

    final t = notification.title.toLowerCase();
    if (t.contains('order') || t.contains('bought') || t.contains('sold')) {
      icon = Icons.shopping_bag_outlined;
      color = Colors.orange;
    } else if (t.contains('message') || t.contains('chat')) {
      icon = Icons.chat_bubble_outline_rounded;
      color = Colors.teal;
    } else if (t.contains('price') || t.contains('offer')) {
      icon = Icons.local_offer_outlined;
      color = Colors.pink;
    } else if (t.contains('alert') || t.contains('security')) {
      icon = Icons.security_outlined;
      color = colorScheme.error;
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}
