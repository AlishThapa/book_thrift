import 'package:book_thrift/features/cart/models/cart_item.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class AddToCart extends CartEvent {
  const AddToCart(this.book);
  final BookListing book;
  @override
  List<Object?> get props => [book];
}

class RemoveFromCart extends CartEvent {
  const RemoveFromCart(this.bookId);
  final String bookId;
  @override
  List<Object?> get props => [bookId];
}

class UpdateQuantity extends CartEvent {
  const UpdateQuantity(this.bookId, this.quantity);
  final String bookId;
  final int quantity;
  @override
  List<Object?> get props => [bookId, quantity];
}

class ToggleSelectItem extends CartEvent {
  const ToggleSelectItem(this.bookId);
  final String bookId;
  @override
  List<Object?> get props => [bookId];
}

class ToggleSelectAll extends CartEvent {
  const ToggleSelectAll(this.isSelected);
  final bool isSelected;
  @override
  List<Object?> get props => [isSelected];
}

class ClearCart extends CartEvent {}

// State
class CartState extends Equatable {
  const CartState({
    this.items = const [],
  });

  final List<CartItem> items;

  double get totalPrice => items
      .where((item) => item.isSelected)
      .fold(0, (sum, item) => sum + (item.book.sellingPrice * item.quantity));

  bool get isAllSelected => items.isNotEmpty && items.every((item) => item.isSelected);

  @override
  List<Object?> get props => [items];
}

// Bloc
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<ToggleSelectItem>(_onToggleSelectItem);
    on<ToggleSelectAll>(_onToggleSelectAll);
    on<ClearCart>(_onClearCart);
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    final existingIndex = state.items.indexWhere((i) => i.book.id == event.book.id);
    if (existingIndex >= 0) {
      final updatedItems = List<CartItem>.from(state.items);
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: updatedItems[existingIndex].quantity + 1,
      );
      emit(CartState(items: updatedItems));
    } else {
      emit(CartState(items: [...state.items, CartItem(book: event.book)]));
    }
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    emit(CartState(items: state.items.where((i) => i.book.id != event.bookId).toList()));
  }

  void _onUpdateQuantity(UpdateQuantity event, Emitter<CartState> emit) {
    final updatedItems = state.items.map((item) {
      if (item.book.id == event.bookId) {
        return item.copyWith(quantity: event.quantity > 0 ? event.quantity : 1);
      }
      return item;
    }).toList();
    emit(CartState(items: updatedItems));
  }

  void _onToggleSelectItem(ToggleSelectItem event, Emitter<CartState> emit) {
    final updatedItems = state.items.map((item) {
      if (item.book.id == event.bookId) {
        return item.copyWith(isSelected: !item.isSelected);
      }
      return item;
    }).toList();
    emit(CartState(items: updatedItems));
  }

  void _onToggleSelectAll(ToggleSelectAll event, Emitter<CartState> emit) {
    final updatedItems = state.items.map((item) {
      return item.copyWith(isSelected: event.isSelected);
    }).toList();
    emit(CartState(items: updatedItems));
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(const CartState());
  }
}
