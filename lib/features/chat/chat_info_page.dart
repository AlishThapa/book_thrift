import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/features/chat/bloc/chat_bloc.dart';
import 'package:book_thrift/features/chat/models/chat_models.dart';
import 'package:book_thrift/shared/widgets/system/app_buttons.dart';

class ChatInfoPage extends StatelessWidget {
  const ChatInfoPage({
    super.key,
    required this.thread,
    required this.chatBloc,
  });

  final ChatThread thread;
  final ChatBloc chatBloc;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Extract images from messages (logic placeholder - assuming text might contain URLs or we add an image field later)
    final mediaMessages = thread.messages.where((m) => m.text.startsWith('http') && (m.text.endsWith('.jpg') || m.text.endsWith('.png'))).toList();

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('Contact Info'),
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.lg),
            // ── Seller Profile Section ───────────────────────────────────
            _buildProfileHeader(colorScheme, textTheme),
            const SizedBox(height: AppSpacing.xl),

            // ── Action Buttons ───────────────────────────────────────────
            _buildActionButtons(context, colorScheme, textTheme),
            const SizedBox(height: AppSpacing.lg),

            // ── Media Section ────────────────────────────────────────────
            _buildMediaSection(mediaMessages, colorScheme, textTheme),
            const SizedBox(height: AppSpacing.xl),

            // ── Delete Chat Button ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: SecondaryButton(
                label: 'Delete Chat',
                icon: Icons.delete_outline_rounded,
                onPressed: () => _confirmDelete(context, colorScheme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [colorScheme.primary.withValues(alpha: 0.2), colorScheme.primary.withValues(alpha: 0.1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Text(
              thread.peerName[0].toUpperCase(),
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          thread.peerName,
          style: textTheme.titleLarge?.copyWith(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          'Seller',
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _CircleActionButton(
          icon: Icons.search_rounded,
          label: 'Search',
          onTap: () {
             ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(content: Text('Search feature coming soon!')),
             );
          },
        ),
        const SizedBox(width: AppSpacing.xl),
        _CircleActionButton(
          icon: Icons.notifications_none_rounded,
          label: 'Mute',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildMediaSection(List<ChatMessage> mediaMessages, ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Media, Links and Docs', style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              Text(
                '${mediaMessages.length}',
                style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (mediaMessages.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text('No media shared yet', style: TextStyle(color: colorScheme.onSurfaceVariant, fontStyle: FontStyle.italic)),
          )
        else
          SizedBox(
            height: 100,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              scrollDirection: Axis.horizontal,
              itemCount: mediaMessages.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: colorScheme.outlineVariant, width: 1),
                    image: DecorationImage(
                      image: NetworkImage(mediaMessages[index].text),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, ColorScheme colorScheme) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colorScheme.surface,
        title: const Text('Delete Chat?'),
        content: const Text('Are you sure you want to delete this conversation? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel', style: TextStyle(color: colorScheme.onSurfaceVariant))),
          TextButton(
            onPressed: () {
              chatBloc.add(DeleteThread(thread.id));
              Navigator.pop(ctx); // Close dialog
              Navigator.pop(context); // Close Info Page
              Navigator.pop(context); // Close Chat Detail Page
            },
            child: Text('Delete', style: TextStyle(color: colorScheme.error)),
          ),
        ],
      ),
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  const _CircleActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              shape: BoxShape.circle,
              border: Border.all(color: colorScheme.outlineVariant, width: 1),
              boxShadow: [
                BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2)),
              ],
            ),
            child: Icon(icon, color: colorScheme.primary),
          ),
          const SizedBox(height: 8),
          Text(label, style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
        ],
      ),
    );
  }
}
