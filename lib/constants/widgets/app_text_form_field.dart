import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:book_thrift/constants/design_tokens.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.readOnly = false,
    this.onChanged,
    this.validator,
    this.inputFormatters,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final String? hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final required = label.contains('*');
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label.replaceAll('*', '').trim(),
              style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.w600, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87),
              children: required ? const [TextSpan(text: ' *', style: TextStyle(color: Colors.red))] : null,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            initialValue: controller == null ? initialValue : null,
            keyboardType: keyboardType,
            obscureText: obscureText,
            readOnly: readOnly,
            onChanged: onChanged,
            validator: validator,
            inputFormatters: inputFormatters,
            maxLines: maxLines,
            decoration: InputDecoration(hintText: hint),
          ),
        ],
      ),
    );
  }
}
