import 'package:auto_route/auto_route.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/constants/size_constants.dart';
import 'package:book_thrift/core/di/injection.dart';
import 'package:book_thrift/constants/widgets/app_text_form_field.dart';
import 'package:book_thrift/features/auth/repository/repo.dart';
import 'package:book_thrift/features/profile/bloc/profile_bloc.dart';
import 'package:book_thrift/core/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 7 || value.length > 11) return 'Must be 7-11 characters';
    if (!value.contains(RegExp(r'[A-Z]'))) return 'Must contain at least 1 capital letter';
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return 'Must contain at least 1 symbol';
    return null;
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    if (_oldPasswordController.text == _newPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New password cannot be the same as old password')),
      );
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final profile = context.read<ProfileBloc>().state.profile;
      final userId = profile?.id;

      if (userId == null) {
        throw 'User ID not found. Please log in again.';
      }

      await getIt<AuthRepository>().changePassword(
        userId: userId,
        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
        confirmNewPassword: _confirmPasswordController.text,
      );
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully')),
      );
      
      // Navigate to profile page. Since Profile is a tab in MainShellRoute, 
      // we navigate to the shell with the profile index (usually 4).
      context.router.replaceAll([MainShellRoute(initialIndex: 4)]);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextFormField(
                label: 'Old Password*',
                controller: _oldPasswordController,
                obscureText: true,
                hint: 'Enter old password',
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              AppTextFormField(
                label: 'New Password*',
                controller: _newPasswordController,
                obscureText: true,
                hint: 'Enter new password',
                validator: _validatePassword,
              ),
              AppTextFormField(
                label: 'Confirm New Password*',
                controller: _confirmPasswordController,
                obscureText: true,
                hint: 'Confirm new password',
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: HeightConstants.md),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Password Rules:',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: HeightConstants.xs),
                    _ruleRow('7-11 characters'),
                    _ruleRow('At least 1 capital letter'),
                    _ruleRow('At least 1 symbol'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: ElevatedButton(
            onPressed: _isLoading ? null : _changePassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Change Password', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget _ruleRow(String rule) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, size: 14, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(rule, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
