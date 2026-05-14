import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/features/chat/models/chat_models.dart';

class ChatThreadCard extends StatelessWidget {
  const ChatThreadCard({super.key, required this.thread, this.onTap});

  final ChatThread thread;
  final VoidCallback? onTap;

  Color _getAvatarColor() {
    final colors = [
      const Color(0xFF9C27B0), // Purple
      const Color(0xFF009688), // Teal
      const Color(0xFFFF7043), // Coral/Orange
      const Color(0xFF4361EE), // Blue
      const Color(0xFFE91E63), // Pink
    ];
    final name = thread.peerName.isEmpty ? 'Unknown' : thread.peerName;
    return colors[name.length % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final lastMessage = thread.messages.isNotEmpty ? thread.messages.last : null;
    final timeStr = DateFormat('jm').format(thread.updatedAt);
    final avatarColor = _getAvatarColor();
    final isUnread = thread.unreadCount > 0;
    final displayName = thread.peerName.isEmpty ? 'Unknown' : thread.peerName;
    final initial = displayName[0].toUpperCase();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 10, offset: const Offset(5, 5))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(color: avatarColor.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Center(
                child: Text(
                  initial,
                  style: TextStyle(color: avatarColor, fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        displayName,
                        style: TextStyle(fontSize: 14, fontWeight: isUnread ? FontWeight.bold : FontWeight.w500, color: colorScheme.onSurface),
                      ),
                      Text(
                        timeStr,
                        style: TextStyle(
                          fontSize: 11,
                          color: isUnread ? colorScheme.primary : colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                          fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Item Tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: avatarColor.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(100)),
                    child: Text(
                      thread.bookTitle,
                      style: TextStyle(color: avatarColor, fontSize: 10, fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lastMessage?.text ?? 'No messages yet',
                          style: TextStyle(
                            fontSize: 12,
                            color: isUnread ? colorScheme.onSurface : colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                            fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isUnread)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(color: colorScheme.primary, shape: BoxShape.circle),
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
