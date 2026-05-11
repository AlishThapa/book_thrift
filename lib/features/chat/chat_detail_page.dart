import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/constants/app_colors.dart';
import 'package:book_thrift/features/chat/bloc/chat_bloc.dart';
import 'package:book_thrift/features/chat/chat_info_page.dart';
import 'package:book_thrift/features/chat/models/chat_models.dart';
import 'package:book_thrift/features/chat/widgets/chat_book_header.dart';
import 'package:book_thrift/features/chat/widgets/chat_bubble.dart';
import 'package:book_thrift/features/chat/widgets/chat_input_field.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({super.key, required this.threadId, required this.listing});
  final String threadId;
  final BookListing listing;

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0, // In a reversed list, 0 is the bottom
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _onAttach() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Share Media', style: AppTextStyles.sectionTitle),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _AttachmentItem(
                    icon: Icons.image_rounded,
                    label: 'Image',
                    color: Colors.orange,
                    onTap: () {
                      Navigator.pop(ctx);
                      context.read<ChatBloc>().add(
                            SendMessage(
                              widget.threadId,
                              '[Image]',
                              type: ChatMessageType.image,
                              mediaUrl: 'https://picsum.photos/400/300',
                              listing: widget.listing,
                            ),
                          );
                    },
                  ),
                  _AttachmentItem(
                    icon: Icons.description_rounded,
                    label: 'Document',
                    color: Colors.blue,
                    onTap: () {
                      Navigator.pop(ctx);
                      context.read<ChatBloc>().add(
                            SendMessage(
                              widget.threadId,
                              'book_notes.pdf',
                              type: ChatMessageType.document,
                              fileName: 'book_notes.pdf',
                              listing: widget.listing,
                            ),
                          );
                    },
                  ),
                  _AttachmentItem(
                    icon: Icons.location_on_rounded,
                    label: 'Location',
                    color: Colors.green,
                    onTap: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      },
      builder: (context, state) {
        final thread = state.threads.where((e) => e.id == widget.threadId).firstOrNull;
        final messages = (thread?.messages ?? []).reversed.toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textPrimary,
            titleSpacing: 0,
            title: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Text(
                    (thread?.peerName ?? 'S')[0].toUpperCase(),
                    style: const TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 10),
                Text(thread?.peerName ?? 'Seller', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert_rounded),
                onPressed: () {
                  if (thread != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatInfoPage(thread: thread, chatBloc: context.read<ChatBloc>()),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: ChatBookHeader(listing: widget.listing),
              ),
              _QuickActionsRow(
                onAction: (text) {
                  context.read<ChatBloc>().add(SendMessage(widget.threadId, text, listing: widget.listing));
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return ChatBubble(message: messages[index]);
                  },
                ),
              ),
              ChatInputField(
                controller: _controller,
                onAttach: _onAttach,
                onSend: () {
                  if (_controller.text.trim().isNotEmpty) {
                    context.read<ChatBloc>().add(
                          SendMessage(widget.threadId, _controller.text.trim(), listing: widget.listing),
                        );
                    _controller.clear();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AttachmentItem extends StatelessWidget {
  const _AttachmentItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 8),
          Text(label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow({required this.onAction});
  final Function(String) onAction;

  @override
  Widget build(BuildContext context) {
    final actions = ['Is this available?', 'Final price?', 'Meetup location?'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: actions.map((text) {
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.xs),
            child: ActionChip(
              label: Text(text, style: const TextStyle(fontSize: 12, color: AppColors.primary)),
              backgroundColor: AppColors.primary.withOpacity(0.05),
              side: BorderSide(color: AppColors.primary.withOpacity(0.1)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              onPressed: () => onAction(text),
            ),
          );
        }).toList(),
      ),
    );
  }
}
