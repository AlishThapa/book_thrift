import 'package:flutter/material.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/constants/widgets/app_surface.dart';
import 'package:book_thrift/constants/widgets/app_text_form_field.dart';
import 'package:book_thrift/core/data/app_repository.dart';
import 'package:book_thrift/core/di/injection.dart';
import 'package:book_thrift/features/auth/models/user_profile.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, this.profile});
  final UserProfile? profile;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController imagePath = TextEditingController(text: widget.profile?.imagePath ?? '');
  late final TextEditingController name = TextEditingController(text: widget.profile?.fullName ?? '');
  late final TextEditingController email = TextEditingController(text: widget.profile?.email ?? '');
  late final TextEditingController phone = TextEditingController(text: widget.profile?.phone ?? '');
  late final TextEditingController institution = TextEditingController(text: widget.profile?.institutionName ?? '');
  late final TextEditingController classOrCourse = TextEditingController(text: widget.profile?.classOrCourse ?? '');
  late final TextEditingController yearSemester = TextEditingController(text: widget.profile?.semesterOrYear ?? '');
  late final TextEditingController location = TextEditingController(text: widget.profile?.location ?? '');

  @override
  void dispose() {
    imagePath.dispose();
    name.dispose();
    email.dispose();
    phone.dispose();
    institution.dispose();
    classOrCourse.dispose();
    yearSemester.dispose();
    location.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorScheme.primary, colorScheme.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, 'Personal Information', Icons.person_outline_rounded),
                  AppSurface(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      children: [
                        AppTextFormField(label: 'Full Name*', controller: name, hint: 'Enter your full name'),
                        AppTextFormField(
                          label: 'Email Address*',
                          controller: email,
                          hint: 'Enter your email',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        AppTextFormField(
                          label: 'Phone Number',
                          controller: phone,
                          hint: 'Enter your phone number',
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildSectionTitle(context, 'Campus & Education', Icons.school_outlined),
                  AppSurface(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      children: [
                        AppTextFormField(label: 'Institution Name', controller: institution, hint: 'College or University name'),
                        AppTextFormField(label: 'Course / Department', controller: classOrCourse, hint: 'e.g. Computer Science'),
                        AppTextFormField(label: 'Current Year / Semester', controller: yearSemester, hint: 'e.g. 2nd Year, 4th Sem'),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildSectionTitle(context, 'Location Info', Icons.location_on_outlined),
                  AppSurface(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: AppTextFormField(label: 'Location / Area', controller: location, hint: 'e.g. Hostels, Near North Gate'),
                  ),
                  const SizedBox(height: AppSpacing.xl * 2),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomAction(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xl),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: imagePath,
                  builder: (context, value, _) {
                    final hasImage = value.text.trim().isNotEmpty;
                    return CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      backgroundImage: hasImage ? NetworkImage(value.text.trim()) : null,
                      child: !hasImage ? const Icon(Icons.person_rounded, size: 60, color: Colors.white) : null,
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.tertiary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.edit_rounded, color: Colors.white, size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(colors: [colorScheme.primary, colorScheme.secondary]),
          ),
          child: ElevatedButton(
            onPressed: () async {
              if (name.text.isEmpty || email.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Name and Email are required')));
                return;
              }

              await getIt<AppRepository>().saveProfile(
                UserProfile(
                  fullName: name.text,
                  email: email.text,
                  phone: phone.text,
                  userType: widget.profile?.userType ?? 'reader',
                  institutionName: institution.text,
                  classOrCourse: classOrCourse.text,
                  semesterOrYear: yearSemester.text,
                  location: location.text,
                  imagePath: imagePath.text,
                ),
              );
              if (!mounted) return;
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text(
              'Save Changes',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
          ),
        ),
      ),
    );
  }
}
