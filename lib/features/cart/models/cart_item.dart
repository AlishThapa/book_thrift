import 'package:book_thrift/features/listing/models/book_listing.dart';
import 'package:equatable/equatable.dart';
import 'package:book_thrift/core/utils/json_helper.dart';

class CartItem extends Equatable {
  const CartItem({
    this.id,
    this.userId,
    this.bookId,
    required this.book,
    this.quantity = 1,
    this.isSelected = false,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final int? userId;
  final int? bookId;
  final BookListing book;
  final int quantity;
  final bool isSelected;
  final String? createdAt;
  final String? updatedAt;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: JsonHelper.toInt(json['id']),
      userId: JsonHelper.toInt(json['user_id']),
      bookId: JsonHelper.toInt(json['book_id']),
      book: BookListing.fromJson(json['book']),
      quantity: JsonHelper.toInt(json['cart_amount']) ?? 1,
      createdAt: JsonHelper.toStringValue(json['created_at']),
      updatedAt: JsonHelper.toStringValue(json['updated_at']),
    );
  }

  CartItem copyWith({
    int? id,
    int? userId,
    int? bookId,
    BookListing? book,
    int? quantity,
    bool? isSelected,
    String? createdAt,
    String? updatedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      bookId: bookId ?? this.bookId,
      book: book ?? this.book,
      quantity: quantity ?? this.quantity,
      isSelected: isSelected ?? this.isSelected,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, userId, bookId, book, quantity, isSelected, createdAt, updatedAt];
}
