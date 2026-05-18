import "package:auto_route/auto_route.dart";
import "package:book_thrift/constants/widgets/toast_message.dart";
import "package:book_thrift/features/auth/bloc/auth_bloc.dart";
import "package:book_thrift/features/auth/widgets/auth_custom_widgets.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:book_thrift/constants/design_tokens.dart";
import "package:book_thrift/constants/widgets/app_text_form_field.dart";
import "package:book_thrift/core/data/app_repository.dart";
import "package:book_thrift/core/di/injection.dart";
import "package:book_thrift/features/auth/models/user_profile.dart";
import "package:book_thrift/core/router/app_router.gr.dart";
import "package:book_thrift/features/settings/bloc/settings_bloc.dart";
import "package:flutter_bloc/flutter_bloc.dart";

@RoutePage()
class AuthEntryPage extends StatefulWidget {
  const AuthEntryPage({super.key});

  @override
  State<AuthEntryPage> createState() => _AuthEntryPageState();
}

class _AuthEntryPageState extends State<AuthEntryPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  void _login() {
    if (_email.text.isEmpty || _password.text.isEmpty) {
      toastMessage(message: "Please enter email and password");
      return;
    }
    context.read<AuthBloc>().add(LoginRequested(_email.text, _password.text));
  }

  void _enter() => context.router.replaceAll([MainShellRoute()]);

  void _showSignup() => context.router.push(const ProfileSetupRoute());

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.success) {
          if (state.userProfile != null) {
            getIt<AppRepository>().saveProfile(state.userProfile!);
          }
          context.router.replaceAll([MainShellRoute()]);
        } else if (state.status == AuthStatus.failure) {
          toastMessage(message: state.errorMessage ?? "Login failed");
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) {
                final isDark = state.themeMode == ThemeMode.dark;
                return IconButton(
                  onPressed: () {
                    context.read<SettingsBloc>().add(ToggleDarkMode(!isDark));
                  },
                  icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, color: colorScheme.primary),
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                children: [
                  const SizedBox(height: 16),
                  const BrandHeader(icon: Icons.auto_stories_rounded, title: "Welcome back", subtitle: "Login to continue buying and\nselling books nearby."),
                  const SizedBox(height: 32),
                  AuthCard(
                    child: Column(
                      children: [
                        AppTextFormField(label: "Email", hint: "you@example.com", controller: _email),
                        AppTextFormField(label: "Password", hint: "Enter your password", controller: _password, obscureText: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return PrimaryBtn(label: "Login", icon: Icons.login_rounded, onTap: _login, isLoading: state.status == AuthStatus.loading);
                    },
                  ),
                  const SizedBox(height: 10),
                  OutlineBtn(label: "Create account", onTap: _showSignup),
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
  final _password = TextEditingController();
  final _phone = TextEditingController();
  final _institution = TextEditingController();
  final _course = TextEditingController();
  final _semester = TextEditingController();
  final _location = TextEditingController();

  Widget _field(
    TextEditingController c,
    String label, {
    TextInputType? type,
    List<TextInputFormatter>? formatters,
    bool obscure = false,
    bool required = true,
    bool readOnly = false,
    String? Function(String?)? validator,
  }) {
    return AppTextFormField(
      label: required ? "$label *" : label,
      controller: c,
      keyboardType: type,
      obscureText: obscure,
      inputFormatters: formatters,
      readOnly: readOnly,
      validator: (v) {
        if (required && (v == null || v.trim().isEmpty)) {
          return "$label is required";
        }
        if (validator != null) {
          return validator(v);
        }
        return null;
      },
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
          BlocBuilder<AuthBloc, AuthState>(
            buildWhen: (previous, current) => previous.selectedUserType != current.selectedUserType,
            builder: (context, state) {
              return DropdownButtonFormField<String>(
                value: state.selectedUserType,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: "student", child: Text("Student")),
                  DropdownMenuItem(value: "parent", child: Text("Parent")),
                  DropdownMenuItem(value: "teacher", child: Text("Teacher")),
                  DropdownMenuItem(value: "reader", child: Text("Reader")),
                ],
                onChanged: (v) => context.read<AuthBloc>().add(UserTypeChanged(v ?? "student")),
              );
            },
          ),
        ],
      ),
    );
  }

  void _onRegister() {
    if (!_formKey.currentState!.validate()) return;

    final profile = UserProfile(
      fullName: _fullName.text,
      email: _email.text,
      password: _password.text,
      phone: _phone.text,
      userType: context.read<AuthBloc>().state.selectedUserType,
      institutionName: _institution.text,
      classOrCourse: _course.text,
      semesterOrYear: _semester.text,
      location: _location.text,
    );

    context.read<AuthBloc>().add(RegisterRequested(profile));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.registered) {
          toastMessage(message: "Registration successful! Please login.");
          context.router.maybePop();
        } else if (state.status == AuthStatus.failure) {
          toastMessage(message: state.errorMessage ?? "Registration failed");
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(3, 3))],
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
                      const SectionLabel(label: "Account"),
                      AuthCard(
                        child: Column(
                          children: [
                            _field(_fullName, "Full Name"),
                            _field(_email, "Email", type: TextInputType.emailAddress),
                            _field(
                              _password,
                              "Password",
                              obscure: true,
                              validator: (v) {
                                if (v == null || v.isEmpty) return null;
                                if (v.length <= 6 || v.length >= 12) {
                                  return "Password must be 7-11 characters long";
                                }
                                if (!RegExp(r'[A-Z]').hasMatch(v)) {
                                  return "Must have at least one capital letter";
                                }
                                if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(v)) {
                                  return "Must have at least one symbol";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const SectionLabel(label: "Personal"),
                      AuthCard(
                        child: Column(
                          children: [
                            _field(_phone, "Phone", type: TextInputType.number, formatters: [FilteringTextInputFormatter.digitsOnly]),
                            _userTypeDropdown(),
                            _field(_location, "Location"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const SectionLabel(label: "Academic"),
                      AuthCard(child: Column(children: [_field(_institution, "Institution"), _field(_course, "Class / Course"), _field(_semester, "Semester / Year")])),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: double.infinity,
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return PrimaryBtn(label: "Sign up & Continue", icon: Icons.check_rounded, onTap: _onRegister, isLoading: state.status == AuthStatus.loading);
                      },
                    ),
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
