import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:book_thrift/constants/design_tokens.dart";
import "package:book_thrift/constants/widgets/app_text_form_field.dart";
import "package:book_thrift/core/data/app_repository.dart";
import "package:book_thrift/core/di/injection.dart";
import "package:book_thrift/features/auth/models/user_profile.dart";
import "package:book_thrift/features/home/homepage.dart";

class AuthEntryPage extends StatefulWidget {
  const AuthEntryPage({super.key});

  @override
  State<AuthEntryPage> createState() => _AuthEntryPageState();
}

class _AuthEntryPageState extends State<AuthEntryPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  void _enter() => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainShellPage()), (_) => false);

  void _showSignup() => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileSetupPage()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
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
                    child: Text("Continue as guest", style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
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
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainShellPage()), (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Center(
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1A1D2E), size: 18),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: EdgeInsets.zero,
                fixedSize: const Size(40, 40),
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
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  children: [
                    Text(
                      "Let's build your profile",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1D2E),
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Fill in your details to get started",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                    ),
                    const SizedBox(height: 32),
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
                      child: Column(children: [
                        _field(_institution, "Institution"),
                        _field(_course, "Class / Course"),
                        _field(_semester, "Semester / Year")
                      ]),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  child: _PrimaryBtn(
                    label: "Sign up & Continue",
                    icon: Icons.check_rounded,
                    onTap: _save,
                  ),
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
          decoration: BoxDecoration(color: const Color(0xFF4F8EF7).withOpacity(0.12), borderRadius: BorderRadius.circular(16)),
          child: const Icon(Icons.auto_stories_rounded, color: Color(0xFF4F8EF7), size: 28),
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFF1A1D2E), height: 1.2),
        ),
        const SizedBox(height: 8),
        Text(subtitle, style: TextStyle(fontSize: 15, color: Colors.grey.shade600, height: 1.5)),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 2))],
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
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
    return SizedBox(
      height: 52,
      child: FilledButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF4F8EF7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF4F8EF7), width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          foregroundColor: const Color(0xFF4F8EF7),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      ),
    );
  }
}
