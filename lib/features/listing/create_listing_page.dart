import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_thrift/constants/design_tokens.dart';
import 'package:book_thrift/constants/app_colors.dart';
import 'package:book_thrift/constants/widgets/app_text_form_field.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';
import 'package:book_thrift/features/listing/bloc/create_listing_bloc.dart';

@RoutePage()
class CreateListingPage extends StatelessWidget {
  const CreateListingPage({super.key, this.listing});
  final BookListing? listing;

  @override
  Widget build(BuildContext context) {
    return _CreateListingView(listing: listing);
  }
}

class _CreateListingView extends StatefulWidget {
  const _CreateListingView({this.listing});
  final BookListing? listing;

  @override
  State<_CreateListingView> createState() => _CreateListingViewState();
}

class _CreateListingViewState extends State<_CreateListingView> {
  final formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  late final Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    final listing = widget.listing;
    _controllers = {
      'title': TextEditingController(text: listing?.title),
      'sellingPrice': TextEditingController(text: listing?.sellingPrice.toStringAsFixed(0)),
      'publisher': TextEditingController(text: listing?.publisher),
      'quantity': TextEditingController(text: listing?.quantity.toString() ?? '1'),
      'description': TextEditingController(text: listing?.description),
      'location': TextEditingController(text: listing?.location),
    };

    if (listing != null) {
      // Initialize bloc with existing listing data if editing
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final bloc = context.read<CreateListingBloc>();
        bloc.add(SeedForm({
          'title': listing.title,
          'category': listing.category,
          'condition': listing.condition,
          'sellingPrice': listing.sellingPrice.toStringAsFixed(0),
          'publisher': listing.publisher,
          'quantity': listing.quantity.toString(),
          'description': listing.description,
          'location': listing.location,
          'imagePaths': listing.imagePaths,
        }, bookId: int.tryParse(listing.id)));
      });
    }
  }

  final List<String> _conditions = ['New', 'Like New', 'Used', 'Old'];
  final List<String> _categories = [
    'School',
    '+2 College',
    'Bachelor & Above',
    'Novels & Fiction',
    'Religion & Spirituality',
    'Self-Help',
    'Children\'s Books',
    'Others',
  ];

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
            Text('Add Photos', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
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
                    Text(title, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
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
      body: BlocConsumer<CreateListingBloc, CreateListingState>(
        listenWhen: (p, c) => p.message != c.message && c.message.isNotEmpty,
        listener: (context, state) {
          if (state.message.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: state.published ? AppColors.success : AppColors.error));
          }
          if (state.published) {
            context.router.maybePop(true);
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
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isEditing = widget.listing != null;

    return AppBar(
      elevation: 0,
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      title: Text(isEditing ? 'Edit Post' : 'Share Post', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
      leading: IconButton(
        onPressed: () => context.router.back(),
        icon: const Icon(Icons.close_rounded),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: TextButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) {
                _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                return;
              }
              context.read<CreateListingBloc>().add(PublishListing());
            },
            style: TextButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: Text(isEditing ? 'Update' : 'Post', style: const TextStyle(fontWeight: FontWeight.bold)),
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
                Text('Quick Listing Form', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
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
                    Text('Book Photos', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    Text('Add up to 5 photos • Better photos = faster sales', style: textTheme.bodySmall),
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
                  Text(canAddMore ? 'Tap to upload images' : '${state.selectedImages.length}/5 photos added', style: textTheme.bodySmall),
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
              Text('Book Details', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildFormField('title', 'Book Title *', hint: 'Enter the book name'),
          _buildCategoryDropdown(),
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
        
        // Normalize condition for matching (API might return lowercase)
        String? selectedValue;
        if (currentValue != null) {
          try {
            selectedValue = _conditions.firstWhere(
              (c) => c.toLowerCase() == currentValue.toLowerCase(),
            );
          } catch (_) {
            selectedValue = null;
          }
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Condition',
                    style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500, color: colorScheme.onSurfaceVariant),
                  ),
                  Text(
                    ' *',
                    style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500, color: Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedValue,
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                hint: Text('Select Condition', style: textTheme.bodyMedium?.copyWith(color: colorScheme.outline)),
                icon: Icon(Icons.keyboard_arrow_down_rounded, color: colorScheme.outline),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerLow,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.outlineVariant, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
                  ),
                ),
                items: _conditions.map((condition) {
                  return DropdownMenuItem(
                    value: condition,
                    child: Text(condition, style: textTheme.bodyMedium),
                  );
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

  Widget _buildCategoryDropdown() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<CreateListingBloc, CreateListingState>(
      buildWhen: (p, c) => p.form['category'] != c.form['category'],
      builder: (context, state) {
        final currentValue = state.form['category']?.toString();
        // Default to 'Others' if not set or not in list
        final selectedValue = _categories.contains(currentValue) ? currentValue : 'Others';

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Category',
                    style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500, color: colorScheme.onSurfaceVariant),
                  ),
                  Text(
                    ' *',
                    style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500, color: Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedValue,
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                hint: Text('Select Category', style: textTheme.bodyMedium?.copyWith(color: colorScheme.outline)),
                icon: Icon(Icons.keyboard_arrow_down_rounded, color: colorScheme.outline),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerLow,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.outlineVariant, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
                  ),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category, style: textTheme.bodyMedium),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    context.read<CreateListingBloc>().add(UpdateListingField('category', value));
                  }
                },
                validator: (value) => (value == null || value.isEmpty) ? 'Category is required' : null,
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
}
