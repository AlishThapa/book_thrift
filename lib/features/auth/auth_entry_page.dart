import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:book_thrift/constants/design_tokens.dart";
import "package:book_thrift/constants/widgets/app_text_form_field.dart";
import "package:book_thrift/core/data/app_repository.dart";
import "package:book_thrift/core/di/injection.dart";
import "package:book_thrift/features/auth/models/user_profile.dart";
import "package:book_thrift/core/router/app_router.gr.dart";

import "../../constants/app_colors.dart";

@RoutePage()
class AuthEntryPage extends StatefulWidget {
  const AuthEntryPage({super.key});

  @override
  State<AuthEntryPage> createState() => _AuthEntryPageState();
}

class _AuthEntryPageState extends State<AuthEntryPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  void _enter() => context.router.replaceAll([MainShellRoute()]);

  void _showSignup() => context.router.push(const ProfileSetupRoute());

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              children: [
                const SizedBox(height: 16),
                _BrandHeader(icon: Icons.auto_stories_rounded, title: "Welcome back", subtitle: "Login to continue buying and\nselling books nearby."),
                const SizedBox(height: 32),
                _Card(
                  child: Column(
                    children: [
                      AppTextFormField(label: "Email", hint: "you@example.com", controller: _email),
                      AppTextFormField(label: "Password", hint: "Enter your password", controller: _password, obscureText: true),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _PrimaryBtn(label: "Login", icon: Icons.login_rounded, onTap: _enter),
                const SizedBox(height: 10),
                _OutlineBtn(label: "Create account", onTap: _showSignup),
                const SizedBox(height: 4),
                Center(
                  child: TextButton(
                    onPressed: _enter,
                    child: Text("Continue as guest", style: TextStyle(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6), fontSize: 13)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

@RoutePage()
class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _verificationCode = TextEditingController(text: "Email verification coming soon");
  final _password = TextEditingController();
  final _phone = TextEditingController();
  final _institution = TextEditingController();
  final _course = TextEditingController();
  final _semester = TextEditingController();
  final _location = TextEditingController();
  String _userType = "student";

  Widget _field(
    TextEditingController c,
    String label, {
    TextInputType? type,
    List<TextInputFormatter>? formatters,
    bool obscure = false,
    bool required = true,
    bool readOnly = false,
  }) {
    return AppTextFormField(
      label: required ? "$label *" : label,
      controller: c,
      keyboardType: type,
      obscureText: obscure,
      inputFormatters: formatters,
      readOnly: readOnly,
      validator: required ? (v) => (v == null || v.trim().isEmpty) ? "$label is required" : null : null,
    );
  }

  Widget _userTypeDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("User Type *", style: AppTextStyles.subtitle),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: _userType,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: "student", child: Text("Student")),
              DropdownMenuItem(value: "parent", child: Text("Parent")),
              DropdownMenuItem(value: "teacher", child: Text("Teacher")),
              DropdownMenuItem(value: "reader", child: Text("Reader")),
            ],
            onChanged: (v) => setState(() => _userType = v ?? "student"),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    await Future.delayed(const Duration(milliseconds: 500));
    await getIt<AppRepository>().saveProfile(
      UserProfile(
        fullName: _fullName.text,
        email: _email.text,
        phone: _phone.text,
        userType: _userType,
        institutionName: _institution.text,
        classOrCourse: _course.text,
        semesterOrYear: _semester.text,
        location: _location.text,
        imagePath: "",
      ),
    );
    if (!mounted) return;
    Navigator.pop(context);
    context.router.replaceAll([MainShellRoute()]);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(3, 3)),
                  // BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2, offset: const Offset(1.5, 1.5)),
                ],
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios_new_rounded, color: colorScheme.onSurface, size: 18),
                style: IconButton.styleFrom(
                  backgroundColor: colorScheme.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.zero,
                  fixedSize: const Size(40, 40),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  children: [
                    Text(
                      "Let's build your profile",
                      textAlign: TextAlign.center,
                      style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text("Fill in your details to get started", textAlign: TextAlign.center, style: textTheme.bodyMedium),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  children: [
                    _SectionLabel(label: "Account"),
                    _Card(
                      child: Column(
                        children: [
                          _field(_fullName, "Full Name"),
                          _field(_email, "Email", type: TextInputType.emailAddress),
                          _field(_verificationCode, "Email Verification Code", required: false, readOnly: true),
                          _field(_password, "Password", obscure: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SectionLabel(label: "Personal"),
                    _Card(
                      child: Column(
                        children: [
                          _field(_phone, "Phone", type: TextInputType.number, formatters: [FilteringTextInputFormatter.digitsOnly]),
                          _userTypeDropdown(),
                          _field(_location, "Location"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SectionLabel(label: "Academic"),
                    _Card(
                      child: Column(children: [_field(_institution, "Institution"), _field(_course, "Class / Course"), _field(_semester, "Semester / Year")]),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  child: _PrimaryBtn(label: "Sign up & Continue", icon: Icons.check_rounded, onTap: _save),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader({required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(16)),
          child: const Icon(Icons.auto_stories_rounded, color: AppColors.primary, size: 28),
        ),
        const SizedBox(height: 20),
        Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, fontSize: 28)),
        const SizedBox(height: 8),
        Text(subtitle, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 10, offset: const Offset(5, 5))],
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.2, color: Colors.grey.shade400),
      ),
    );
  }
}

class _PrimaryBtn extends StatelessWidget {
  const _PrimaryBtn({required this.label, required this.icon, required this.onTap});
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: FilledButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0, // Handled by Container shadow
        ),
      ),
    );
  }
}

class _OutlineBtn extends StatelessWidget {
  const _OutlineBtn({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(color: colorScheme.primary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          foregroundColor: colorScheme.primary,
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      ),
    );
  }
}
