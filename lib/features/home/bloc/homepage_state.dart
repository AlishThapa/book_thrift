part of 'homepage_bloc.dart';

class HomepageState extends Equatable {
  const HomepageState({
    this.loading = true,
    this.selectedCategory = 'All',
    this.listings = const [],
  });

  final bool loading;
  final String selectedCategory;
  final List<BookListing> listings;

  HomepageState copyWith({
    bool? loading,
    String? selectedCategory,
    List<BookListing>? listings,
  }) =>
      HomepageState(
        loading: loading ?? this.loading,
        selectedCategory: selectedCategory ?? this.selectedCategory,
        listings: listings ?? this.listings,
      );

  @override
  List<Object?> get props => [loading, selectedCategory, listings];
}