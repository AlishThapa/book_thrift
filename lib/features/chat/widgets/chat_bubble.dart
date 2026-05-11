import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:book_thrift/constants/app_colors.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/features/chat/models/chat_models.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final timeStr = DateFormat('jm').format(message.sentAt);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: _getPadding(),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppRadius.lg),
            topRight: const Radius.circular(AppRadius.lg),
            bottomLeft: Radius.circular(isMe ? AppRadius.lg : 0),
            bottomRight: Radius.circular(isMe ? 0 : AppRadius.lg),
          ),
          boxShadow: [
            if (!isMe)
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildContent(context),
            const SizedBox(height: 4),
            Text(
              timeStr,
              style: TextStyle(
                color: isMe ? Colors.white70 : AppColors.textLight,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  EdgeInsets _getPadding() {
    if (message.type == ChatMessageType.image) {
      return const EdgeInsets.all(4);
    }
    return const EdgeInsets.symmetric(horizontal: 14, vertical: 10);
  }

  Widget _buildContent(BuildContext context) {
    switch (message.type) {
      case ChatMessageType.text:
        return Text(
          message.text,
          style: TextStyle(
            color: message.isMe ? Colors.white : AppColors.textPrimary,
            fontSize: 15,
            height: 1.4,
          ),
        );
      case ChatMessageType.image:
        return _buildImageContent();
      case ChatMessageType.document:
        return _buildDocumentContent();
    }
  }

  Widget _buildImageContent() {
    final path = message.mediaUrl ?? '';
    final isNetwork = path.startsWith('http');
    
    Widget image;
    if (isNetwork) {
      image = CachedNetworkImage(
        imageUrl: path,
        fit: BoxFit.cover,
        placeholder: (context, url) => const SizedBox(
          width: 200,
          height: 200,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error_outline),
      );
    } else {
      image = Image.file(
        File(path),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.error_outline),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: image,
    );
  }

  Widget _buildDocumentContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.description_rounded,
          color: message.isMe ? Colors.white70 : AppColors.primary,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            message.fileName ?? 'Document',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: message.isMe ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
