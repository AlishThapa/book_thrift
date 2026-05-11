import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:book_thrift/core/data/app_repository.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';
import 'package:book_thrift/features/listing/models/listing_draft.dart';

part 'create_listing_event.dart';
part 'create_listing_state.dart';

class CreateListingBloc extends Bloc<CreateListingEvent, CreateListingState> {
  CreateListingBloc(this.repo) : super(const CreateListingState()) {
    on<UpdateListingField>(_updateField);
    on<SeedForm>(_seedForm);
    on<SaveDraft>(_saveDraft);
    on<PublishListing>(_publish);
    on<AddImages>(_addImages);
    on<RemoveImage>(_removeImage);
    on<PickImagesFromGallery>(_pickImagesFromGallery);
    on<PickImageFromCamera>(_pickImageFromCamera);
    on<ClearImages>(_clearImages);
  }

  final AppRepository repo;
  final ImagePicker _picker = ImagePicker();

  void _updateField(UpdateListingField event, Emitter<CreateListingState> emit) {
    emit(state.copyWith(form: {...state.form, event.key: event.value}));
  }

  void _seedForm(SeedForm event, Emitter<CreateListingState> emit) {
    final images = (event.form['imagePaths'] as List?)?.cast<String>() ?? [];
    emit(state.copyWith(
      form: {...state.form, ...event.form},
      selectedImages: images,
    ));
  }

  void _addImages(AddImages event, Emitter<CreateListingState> emit) {
    final newImages = [...state.selectedImages, ...event.imagePaths];
    // Limit to 5 images
    final limitedImages = newImages.take(5).toList();
    emit(state.copyWith(selectedImages: limitedImages));
  }

  void _removeImage(RemoveImage event, Emitter<CreateListingState> emit) {
    final updatedImages = [...state.selectedImages];
    if (event.index >= 0 && event.index < updatedImages.length) {
      updatedImages.removeAt(event.index);
      emit(state.copyWith(selectedImages: updatedImages));
    }
  }

  Future<void> _pickImagesFromGallery(PickImagesFromGallery event, Emitter<CreateListingState> emit) async {
    try {
      emit(state.copyWith(isPickingImages: true));

      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 80,
        maxWidth: 1200,
      );

      if (images.isNotEmpty) {
        final imagePaths = images.map((image) => image.path).toList();
        add(AddImages(imagePaths));
      }

      emit(state.copyWith(isPickingImages: false));
    } catch (e) {
      emit(state.copyWith(
        isPickingImages: false,
        message: 'Error picking images: $e',
      ));
    }
  }

  Future<void> _pickImageFromCamera(PickImageFromCamera event, Emitter<CreateListingState> emit) async {
    try {
      emit(state.copyWith(isPickingImages: true));

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1200,
      );

      if (image != null) {
        add(AddImages([image.path]));
      }

      emit(state.copyWith(isPickingImages: false));
    } catch (e) {
      emit(state.copyWith(
        isPickingImages: false,
        message: 'Error taking photo: $e',
      ));
    }
  }

  void _clearImages(ClearImages event, Emitter<CreateListingState> emit) {
    emit(state.copyWith(selectedImages: []));
  }

  Future<void> _saveDraft(SaveDraft event, Emitter<CreateListingState> emit) async {
    final id = state.form['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();
    final formWithImages = {
      ...state.form,
      'imagePaths': state.selectedImages,
    };

    await repo.saveDraft(ListingDraft(
      id: id,
      data: formWithImages,
      updatedAt: DateTime.now(),
    ));

    emit(state.copyWith(message: 'Draft saved'));
  }

  Future<void> _publish(PublishListing event, Emitter<CreateListingState> emit) async {
    final f = state.form;
    if ((f['title'] ?? '').toString().trim().isEmpty ||
        (f['condition'] ?? '').toString().trim().isEmpty ||
        (f['sellingPrice'] ?? '').toString().trim().isEmpty ||
        (f['location'] ?? '').toString().trim().isEmpty) {
      emit(state.copyWith(message: 'Book name, condition, selling price, and location are required'));
      return;
    }

    final id = f['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();
    await repo.saveListing(BookListing(
      id: id,
      sellerId: 'me',
      title: f['title'] ?? '',
      author: 'Unknown',
      category: 'General',
      subject: 'General',
      institution: '',
      classOrCourse: '',
      semester: '',
      edition: '',
      publisher: f['publisher'] ?? '',
      isbn: null,
      condition: f['condition'] ?? 'Good',
      description: f['description'] ?? '',
      originalPrice: 0,
      sellingPrice: double.tryParse('${f['sellingPrice'] ?? 0}') ?? 0,
      negotiable: true,
      quantity: int.tryParse('${f['quantity'] ?? 1}') ?? 1,
      imagePaths: state.selectedImages,
      location: f['location'] ?? 'Unknown',
      deliveryMethod: ['Meetup'],
      isAvailable: true,
      isReserved: false,
      status: 'active',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));

    // Remove from drafts if it was a draft
    await repo.deleteDraft(id);

    emit(state.copyWith(
      published: true,
      message: 'Listing published successfully!',
      selectedImages: [], // Clear images after publishing
      form: {}, // Clear form after publishing
    ));
  }
}