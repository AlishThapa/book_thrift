import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:book_thrift/constants/design_tokens.dart';

class AppTextFormField extends StatefulWidget {
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
    this.suffixIcon,
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
  final Widget? suffixIcon;

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final required = widget.label.contains('*');

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: widget.label.replaceAll('*', '').trim(),
              style: AppTextStyles.subtitle.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withValues(alpha: 0.8),
              ),
              children: required ? [const TextSpan(text: ' *', style: TextStyle(color: Colors.red))] : null,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: widget.controller,
            initialValue: widget.controller == null ? widget.initialValue : null,
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
            keyboardType: widget.keyboardType,
            obscureText: _obscured,
            readOnly: widget.readOnly,
            onChanged: widget.onChanged,
            validator: widget.validator,
            inputFormatters: widget.inputFormatters,
            maxLines: _obscured ? 1 : widget.maxLines,
            decoration: InputDecoration(
              hintText: widget.hint,
              fillColor: colorScheme.surfaceContainerHigh,
              suffixIcon: widget.obscureText
                  ? IconButton(
                      onPressed: () => setState(() => _obscured = !_obscured),
                      icon: Icon(
                        _obscured ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                        size: 20,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    )
                  : widget.suffixIcon,
            ),
          ),
        ],
      ),
    );
  }
}
