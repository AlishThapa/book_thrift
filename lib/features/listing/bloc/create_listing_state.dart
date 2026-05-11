part of 'create_listing_bloc.dart';

class CreateListingState extends Equatable {
  const CreateListingState({
    this.step = 0,
    this.form = const {},
    this.published = false,
    this.message = '',
    this.selectedImages = const [],
    this.isPickingImages = false,
  });

  final int step;
  final Map<String, dynamic> form;
  final bool published;
  final String message;
  final List<String> selectedImages;
  final bool isPickingImages;

  CreateListingState copyWith({
    int? step,
    Map<String, dynamic>? form,
    bool? published,
    String? message,
    List<String>? selectedImages,
    bool? isPickingImages,
  }) =>
      CreateListingState(
        step: step ?? this.step,
        form: form ?? this.form,
        published: published ?? this.published,
        message: message ?? this.message,
        selectedImages: selectedImages ?? this.selectedImages,
        isPickingImages: isPickingImages ?? this.isPickingImages,
      );

  @override
  List<Object?> get props => [step, form, published, message, selectedImages, isPickingImages];
}