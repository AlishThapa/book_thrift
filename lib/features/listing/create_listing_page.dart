import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/constants/app_colors.dart';
import 'package:book_thrift/constants/widgets/app_text_form_field.dart';
import 'package:book_thrift/core/data/app_repository.dart';
import 'package:book_thrift/core/di/injection.dart';
import 'package:book_thrift/features/listing/bloc/create_listing_bloc.dart';
import 'package:book_thrift/features/listing/models/listing_draft.dart';

class CreateListingPage extends StatelessWidget {
  const CreateListingPage({super.key, this.initialDraft});

  final ListingDraft? initialDraft;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateListingBloc(getIt<AppRepository>())..add(SeedForm(initialDraft?.data ?? const {})),
      child: const _CreateListingView(),
    );
  }
}

class _CreateListingView extends StatefulWidget {
  const _CreateListingView();

  @override
  State<_CreateListingView> createState() => _CreateListingViewState();
}

class _CreateListingViewState extends State<_CreateListingView> {
  final formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  final Map<String, TextEditingController> _controllers = {
    'title': TextEditingController(),
    'condition': TextEditingController(),
    'sellingPrice': TextEditingController(),
    'publisher': TextEditingController(),
    'quantity': TextEditingController(text: '1'),
    'description': TextEditingController(),
    'location': TextEditingController(),
  };

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  void _showImageSourceSelection() {
    final bloc = context.read<CreateListingBloc>(); // capture before sheet opens

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.neutral, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Add Photos',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildImageSourceOption(
              context: context,
              icon: Icons.photo_library_rounded,
              title: 'Choose from Gallery',
              subtitle: 'Select multiple photos',
              onTap: () {
                Navigator.pop(context);
                bloc.add(PickImagesFromGallery());
              },
            ),
            const SizedBox(height: AppSpacing.xs),
            _buildImageSourceOption(
              context: context,
              icon: Icons.camera_alt_rounded,
              title: 'Take Photo',
              subtitle: 'Use camera to capture',
              onTap: () {
                Navigator.pop(context);
                bloc.add(PickImageFromCamera());
              },
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSourceOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.neutralLight,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: AppColors.surface, size: 24),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                    Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: AppColors.neutral, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildModernAppBar(),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<CreateListingBloc, CreateListingState>(
              listenWhen: (p, c) => p.message != c.message && c.message.isNotEmpty,
              listener: (context, state) {
                if (state.message.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: state.published ? AppColors.success : AppColors.error,
                    ),
                  );
                }
                if (state.published) {
                  Navigator.pop(context);
                }
              },
              builder: (context, state) {
                // Populate controllers from state form
                if (_controllers['title']!.text.isEmpty && state.form.isNotEmpty) {
                  for (final entry in _controllers.entries) {
                    final value = state.form[entry.key]?.toString();
                    if (value != null && value.isNotEmpty) {
                      entry.value.text = value;
                    }
                  }
                }

                return SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeaderSection(),
                        const SizedBox(height: AppSpacing.lg),
                        _buildImageSection(state),
                        const SizedBox(height: AppSpacing.lg),
                        _buildFormSection(),
                        const SizedBox(height: 100), // Space for floating buttons
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButtons(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,

      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sell Your Book',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          Text('Create a listing in minutes ✨', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.accent.withValues(alpha: 0.1), AppColors.accent.withValues(alpha: 0.2)]),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome, color: AppColors.accent, size: 16),
              const SizedBox(width: 4),
              Text(
                'Quick List',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.accent, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.primary.withValues(alpha: 0.1), AppColors.secondary.withValues(alpha: 0.1)]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16)),
            child: Icon(Icons.sell_rounded, color: AppColors.surface, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Listing Form',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text('Fill in the essentials to publish quickly', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(CreateListingState state) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.camera_alt_rounded, color: AppColors.accent, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Book Photos',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    Text(
                      'Add up to 5 photos • Better photos = faster sales',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              if (state.isPickingImages) SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildImageGrid(state),
        ],
      ),
    );
  }

  Widget _buildImageGrid(CreateListingState state) {
    return Column(
      children: [
        if (state.selectedImages.isNotEmpty) ...[
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: state.selectedImages.length,
              itemBuilder: (context, index) => _buildImagePreview(index, state.selectedImages[index]),
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        _buildAddImageButton(state),
      ],
    );
  }

  Widget _buildImagePreview(int index, String imagePath) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(
              File(imagePath),
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppColors.neutralLight,
                child: Icon(Icons.error, color: AppColors.error, size: 32),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => context.read<CreateListingBloc>().add(RemoveImage(index)),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.close, color: AppColors.surface, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddImageButton(CreateListingState state) {
    final canAddMore = state.selectedImages.length < 5;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: canAddMore && !state.isPickingImages ? _showImageSourceSelection : null,
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(color: canAddMore ? AppColors.primary.withValues(alpha: 0.3) : AppColors.neutral.withValues(alpha: 0.3), width: 2, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: canAddMore ? AppColors.primary.withValues(alpha: 0.1) : AppColors.neutral.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.add_a_photo_rounded, color: canAddMore ? AppColors.primary : AppColors.neutral, size: 24),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    canAddMore ? 'Add Photos' : 'Maximum 5 photos',
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: canAddMore ? AppColors.primary : AppColors.neutral),
                  ),
                  Text(
                    canAddMore ? 'Tap to upload images' : '${state.selectedImages.length}/5 photos added',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.edit_note_rounded, color: AppColors.secondary, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Book Details',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildFormField('title', 'Book Title *', hint: 'Enter the book name'),
          _buildFormField('condition', 'Condition *', hint: 'New / Like New / Good / Fair'),
          _buildFormField('sellingPrice', 'Selling Price *', type: TextInputType.number, hint: '₹ Enter price'),
          _buildFormField('publisher', 'Publisher', required: false, hint: 'Book publisher (optional)'),
          _buildFormField('quantity', 'Quantity', type: TextInputType.number, hint: 'Number of copies'),
          _buildFormField('description', 'Description', required: false, maxLines: 4, hint: 'Additional details about the book'),
          _buildFormField('location', 'Location *', hint: 'Your city/area'),
        ],
      ),
    );
  }

  Widget _buildFormField(String key, String label, {TextInputType? type, bool required = true, int maxLines = 1, String? hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppTextFormField(
        label: label,
        controller: _controllers[key],
        hint: hint,
        keyboardType: type,
        maxLines: maxLines,
        validator: required ? (v) => (v == null || v.trim().isEmpty) ? '${label.replaceAll('*', '').trim()} is required' : null : null,
        onChanged: (v) => context.read<CreateListingBloc>().add(UpdateListingField(key, v)),
      ),
    );
  }

  Widget _buildFloatingActionButtons() {
    return BlocBuilder<CreateListingBloc, CreateListingState>(
      builder: (context, state) {
        final isEdit = state.form['id'] != null;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border, width: 1.5),
                    boxShadow: [BoxShadow(color: AppColors.neutral.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 4))],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => context.read<CreateListingBloc>().add(SaveDraft()),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bookmark_border_rounded, color: AppColors.textSecondary, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Save Draft',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                flex: 2,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [AppColors.accent, AppColors.accentDark]),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: AppColors.accent.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6))],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        if (!formKey.currentState!.validate()) {
                          // Scroll to the first error field
                          _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                          return;
                        }
                        context.read<CreateListingBloc>().add(PublishListing());
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(isEdit ? Icons.check_circle_outline_rounded : Icons.publish_rounded, color: AppColors.surface, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              isEdit ? 'Publish Changes' : 'Publish Listing',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.surface),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
