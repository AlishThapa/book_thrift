import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'category_listing_event.dart';
part 'category_listing_state.dart';

class CategorylistingBloc extends Bloc<CategoryListingEvent, CategoryListingState> { CategorylistingBloc() : super(const CategoryListingState()); }
