import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_thrift/constants/app_colors.dart';
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
    // Extract images from messages (logic placeholder - assuming text might contain URLs or we add an image field later)
    final mediaMessages = thread.messages.where((m) => m.text.startsWith('http') && (m.text.endsWith('.jpg') || m.text.endsWith('.png'))).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Contact Info'),
        elevation: 0,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.lg),
            // ── Seller Profile Section ───────────────────────────────────
            _buildProfileHeader(),
            const SizedBox(height: AppSpacing.xl),

            // ── Action Buttons ───────────────────────────────────────────
            _buildActionButtons(context),
            const SizedBox(height: AppSpacing.lg),

            // ── Media Section ────────────────────────────────────────────
            _buildMediaSection(mediaMessages),
            const SizedBox(height: AppSpacing.xl),

            // ── Delete Chat Button ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: SecondaryButton(
                label: 'Delete Chat',
                icon: Icons.delete_outline_rounded,
                onPressed: () => _confirmDelete(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [AppColors.primary.withOpacity(0.2), AppColors.primary.withOpacity(0.1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Text(
              thread.peerName[0].toUpperCase(),
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          thread.peerName,
          style: AppTextStyles.sectionTitle.copyWith(fontSize: 22),
        ),
        Text(
          'Seller',
          style: AppTextStyles.subtitle,
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
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

  Widget _buildMediaSection(List<ChatMessage> mediaMessages) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Media, Links and Docs', style: AppTextStyles.cardTitle),
              Text(
                '${mediaMessages.length}',
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (mediaMessages.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text('No media shared yet', style: TextStyle(color: AppColors.textLight, fontStyle: FontStyle.italic)),
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
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
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

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Chat?'),
        content: const Text('Are you sure you want to delete this conversation? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              chatBloc.add(DeleteThread(thread.id));
              Navigator.pop(ctx); // Close dialog
              Navigator.pop(context); // Close Info Page
              Navigator.pop(context); // Close Chat Detail Page
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
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
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
              ],
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          Text(label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
