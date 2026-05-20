import 'package:book_thrift/core/services/location_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:book_thrift/features/listing/repo/listing_repo.dart';
import 'package:logger/logger.dart';

part 'create_listing_event.dart';
part 'create_listing_state.dart';

class CreateListingBloc extends Bloc<CreateListingEvent, CreateListingState> {
  CreateListingBloc(this.repo, this._locationService) : super(const CreateListingState()) {
    on<UpdateListingField>(_updateField);
    on<SeedForm>(_seedForm);
    on<PublishListing>(_publish);
    on<AddImages>(_addImages);
    on<RemoveImage>(_removeImage);
    on<PickImagesFromGallery>(_pickImagesFromGallery);
    on<PickImageFromCamera>(_pickImageFromCamera);
    on<ClearImages>(_clearImages);
  }

  final ListingRepo repo;
  final LocationService _locationService;
  final ImagePicker _picker = ImagePicker();

  void _updateField(UpdateListingField event, Emitter<CreateListingState> emit) {
    emit(state.copyWith(form: {...state.form, event.key: event.value}));
  }

  void _seedForm(SeedForm event, Emitter<CreateListingState> emit) {
    final images = (event.form['imagePaths'] as List?)?.cast<String>() ?? [];
    final initialForm = {...state.form, ...event.form};
    if (initialForm['category'] == null) {
      initialForm['category'] = 'Others';
    }
    emit(state.copyWith(
      form: initialForm,
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

  Future<void> _publish(PublishListing event, Emitter<CreateListingState> emit) async {
    final f = state.form;
    if ((f['title'] ?? '').toString().trim().isEmpty ||
        (f['condition'] ?? '').toString().trim().isEmpty ||
        (f['sellingPrice'] ?? '').toString().trim().isEmpty ||
        (f['location'] ?? '').toString().trim().isEmpty) {
      emit(state.copyWith(message: 'Book name, condition, selling price, and location are required'));
      return;
    }

    try {
      emit(state.copyWith(isPickingImages: true)); // Reusing isPickingImages as a general loading state

      final hasAsked = await _locationService.hasBeenAsked();
      final isGranted = await _locationService.isPermissionGranted();

      LocationPermissionStatus permissionStatus = LocationPermissionStatus.notAsked;
      if (hasAsked) {
        permissionStatus = isGranted ? LocationPermissionStatus.granted : LocationPermissionStatus.denied;
      }
      
      Logger().i("Publishing: Location permission status - hasAsked: $hasAsked, isGranted: $isGranted, permissionStatus: $permissionStatus");

      double? lat;
      double? lng;

      if (permissionStatus == LocationPermissionStatus.granted) {
        await _locationService.updateLocation();
        lat = _locationService.getCachedLat();
        lng = _locationService.getCachedLng();
        Logger().i("Publishing: Fetched coordinates - Lat: $lat, Lng: $lng");
      } else {
        Logger().w("Publishing: Location permission not granted or not asked, skipping coordinates");
      }

      await repo.postBook(
        title: f['title'] ?? '',
        condition: f['condition'] ?? 'Good',
        price: double.tryParse('${f['sellingPrice'] ?? 0}') ?? 0,
        quantity: int.tryParse('${f['quantity'] ?? 1}') ?? 1,
        description: f['description'] ?? '',
        location: f['location'] ?? 'Unknown',
        category: f['category'] ?? 'Others',
        imagePaths: state.selectedImages,
        latitude: lat,
        longitude: lng,
      );

      emit(state.copyWith(
        published: true,
        message: 'Listing published successfully!',
        selectedImages: [], // Clear images after publishing
        form: {}, // Clear form after publishing
        isPickingImages: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        message: 'Error publishing listing: $e',
        isPickingImages: false,
      ));
    }
  }
}