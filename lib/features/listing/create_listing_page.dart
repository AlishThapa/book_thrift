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
    'sellingPrice': TextEditingController(),
    'publisher': TextEditingController(),
    'quantity': TextEditingController(text: '1'),
    'description': TextEditingController(),
    'location': TextEditingController(),
  };

  final List<String> _conditions = ['New', 'Like New', 'Used', 'Old'];

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  void _showImageSourceSelection() {
    final bloc = context.read<CreateListingBloc>();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: colorScheme.outline, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Add Photos',
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: colorScheme.surfaceContainerLow,
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
                decoration: BoxDecoration(color: colorScheme.primary, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: colorScheme.onPrimary, size: 24),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(subtitle, style: textTheme.bodySmall),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: colorScheme.outline, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
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
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    for (final controller in _controllers.values) {
                      controller.clear();
                    }
                    _controllers['quantity']?.text = '1';
                  }
                }
              },
              builder: (context, state) {
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
                        const SizedBox(height: 100),
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppBar(
      elevation: 0,
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sell Your Book',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text('Create a listing in minutes ✨', style: textTheme.bodySmall),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [colorScheme.tertiary.withValues(alpha: 0.1), colorScheme.tertiary.withValues(alpha: 0.2)]),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colorScheme.tertiary.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome, color: colorScheme.tertiary, size: 16),
              const SizedBox(width: 4),
              Text(
                'Quick List',
                style: textTheme.labelSmall?.copyWith(color: colorScheme.tertiary, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderSection() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [colorScheme.primary.withValues(alpha: 0.1), colorScheme.secondary.withValues(alpha: 0.1)]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: colorScheme.primary, borderRadius: BorderRadius.circular(16)),
            child: Icon(Icons.sell_rounded, color: colorScheme.onPrimary, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Listing Form',
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text('Fill in the essentials to publish quickly', style: textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(CreateListingState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: colorScheme.tertiary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.camera_alt_rounded, color: colorScheme.tertiary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Book Photos',
                      style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Add up to 5 photos • Better photos = faster sales',
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (state.isPickingImages) SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: colorScheme.primary)),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline),
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
                color: colorScheme.surfaceContainerLow,
                child: Icon(Icons.error, color: colorScheme.error, size: 32),
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
                decoration: BoxDecoration(color: colorScheme.error, borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.close, color: colorScheme.onError, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddImageButton(CreateListingState state) {
    final canAddMore = state.selectedImages.length < 5;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: canAddMore && !state.isPickingImages ? _showImageSourceSelection : null,
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(color: canAddMore ? colorScheme.primary.withValues(alpha: 0.3) : colorScheme.outline, width: 2, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: canAddMore ? colorScheme.primary.withValues(alpha: 0.1) : colorScheme.outline.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.add_a_photo_rounded, color: canAddMore ? colorScheme.primary : colorScheme.outline, size: 24),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    canAddMore ? 'Add Photos' : 'Maximum 5 photos',
                    style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: canAddMore ? colorScheme.primary : colorScheme.outline),
                  ),
                  Text(
                    canAddMore ? 'Tap to upload images' : '${state.selectedImages.length}/5 photos added',
                    style: textTheme.bodySmall,
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: colorScheme.secondary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.edit_note_rounded, color: colorScheme.secondary, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Book Details',
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildFormField('title', 'Book Title *', hint: 'Enter the book name'),
          _buildConditionDropdown(),
          _buildFormField('sellingPrice', 'Selling Price *', type: TextInputType.number, hint: 'NPR Enter price'),
          _buildFormField('publisher', 'Publisher', required: false, hint: 'Book publisher (optional)'),
          _buildFormField('quantity', 'Quantity', type: TextInputType.number, hint: 'Number of copies'),
          _buildFormField('description', 'Description', required: false, maxLines: 4, hint: 'Additional details about the book'),
          _buildFormField('location', 'Location *', hint: 'Your city/area'),
        ],
      ),
    );
  }

  Widget _buildConditionDropdown() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<CreateListingBloc, CreateListingState>(
      buildWhen: (p, c) => p.form['condition'] != c.form['condition'],
      builder: (context, state) {
        final currentValue = state.form['condition']?.toString();
        // Ensure the value exists in our list, otherwise null
        final selectedValue = _conditions.contains(currentValue) ? currentValue : null;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Condition *',
                style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500, color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedValue,
                hint: Text('Select Condition', style: textTheme.bodyMedium?.copyWith(color: colorScheme.outline)),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerLow,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colorScheme.outlineVariant, width: 1)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colorScheme.primary, width: 1.5)),
                ),
                items: _conditions.map((condition) {
                  return DropdownMenuItem(value: condition, child: Text(condition));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    context.read<CreateListingBloc>().add(UpdateListingField('condition', value));
                  }
                },
                validator: (value) => (value == null || value.isEmpty) ? 'Condition is required' : null,
              ),
            ],
          ),
        );
      },
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colorScheme.primary.withValues(alpha: 0.5), width: 1.5),
                    boxShadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
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
                            Icon(Icons.bookmark_border_rounded, color: colorScheme.primary, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Save Draft',
                              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.primary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.8)]),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: colorScheme.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6))],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        if (!formKey.currentState!.validate()) {
                          _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                          return;
                        }
                        context.read<CreateListingBloc>().add(PublishListing());
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(isEdit ? Icons.check_circle_outline_rounded : Icons.publish_rounded, color: colorScheme.onPrimary, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              isEdit ? 'Publish' : 'Publish',
                              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onPrimary),
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
