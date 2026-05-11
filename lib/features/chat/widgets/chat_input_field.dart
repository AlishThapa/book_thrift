import 'package:flutter/material.dart';
import 'package:book_thrift/constants/app_colors.dart';
import 'package:book_thrift/constants/design_tokens.dart';

class ChatInputField extends StatelessWidget {
  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onAttach,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onAttach;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              onPressed: onAttach,
              icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary, size: 28),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.neutralLight.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: controller,
                  maxLines: 4,
                  minLines: 1,
                  style: const TextStyle(fontSize: 15),
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: AppColors.textLight, fontSize: 14),
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, value, _) {
                final isEmpty = value.text.trim().isEmpty;
                return GestureDetector(
                  onTap: isEmpty ? null : onSend,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isEmpty ? AppColors.neutralLight : AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        if (!isEmpty)
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                      ],
                    ),
                    child: Icon(
                      Icons.send_rounded,
                      color: isEmpty ? AppColors.neutral : Colors.white,
                      size: 20,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
