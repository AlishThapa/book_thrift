import 'package:book_thrift/features/listing/models/book_listing.dart';
import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  const CartItem({
    required this.book,
    this.quantity = 1,
    this.isSelected = false,
  });

  final BookListing book;
  final int quantity;
  final bool isSelected;

  CartItem copyWith({
    BookListing? book,
    int? quantity,
    bool? isSelected,
  }) {
    return CartItem(
      book: book ?? this.book,
      quantity: quantity ?? this.quantity,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [book, quantity, isSelected];
}
