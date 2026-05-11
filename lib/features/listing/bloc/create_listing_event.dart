
part of 'create_listing_bloc.dart';

sealed class CreateListingEvent extends Equatable {
  const CreateListingEvent();
  @override
  List<Object?> get props => [];
}

class UpdateListingField extends CreateListingEvent {
  const UpdateListingField(this.key, this.value);
  final String key;
  final dynamic value;

  @override
  List<Object?> get props => [key, value];
}

class SeedForm extends CreateListingEvent {
  const SeedForm(this.form);
  final Map<String, dynamic> form;

  @override
  List<Object?> get props => [form];
}

class NextStep extends CreateListingEvent {}

class PreviousStep extends CreateListingEvent {}

class SaveDraft extends CreateListingEvent {}

class PublishListing extends CreateListingEvent {}

// Image management events
class AddImages extends CreateListingEvent {
  const AddImages(this.imagePaths);
  final List<String> imagePaths;

  @override
  List<Object?> get props => [imagePaths];
}

class RemoveImage extends CreateListingEvent {
  const RemoveImage(this.index);
  final int index;

  @override
  List<Object?> get props => [index];
}

class PickImagesFromGallery extends CreateListingEvent {}

class PickImageFromCamera extends CreateListingEvent {}

class ClearImages extends CreateListingEvent {}