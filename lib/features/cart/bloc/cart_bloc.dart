import 'package:book_thrift/features/cart/models/cart_item.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';
import 'package:book_thrift/features/cart/repo/cart_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

enum CartStatus { initial, loading, success, failure }

// Events
abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {}

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
    this.status = CartStatus.initial,
    this.errorMessage = '',
  });

  final List<CartItem> items;
  final CartStatus status;
  final String errorMessage;

  double get totalPrice => items
      .where((item) => item.isSelected)
      .fold(0, (sum, item) => sum + (item.book.sellingPrice * item.quantity));

  bool get isAllSelected => items.isNotEmpty && items.every((item) => item.isSelected);

  CartState copyWith({
    List<CartItem>? items,
    CartStatus? status,
    String? errorMessage,
  }) {
    return CartState(
      items: items ?? this.items,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [items, status, errorMessage];
}

// Bloc
class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepo _cartRepo;

  CartBloc(this._cartRepo) : super(const CartState()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<ToggleSelectItem>(_onToggleSelectItem);
    on<ToggleSelectAll>(_onToggleSelectAll);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading));
    try {
      final items = await _cartRepo.getCart();
      emit(state.copyWith(items: items, status: CartStatus.success));
    } catch (e) {
      emit(state.copyWith(status: CartStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    // We don't set global loading because we might want to show a specific loading on the button
    // But as per guidelines, let's use the status.
    emit(state.copyWith(status: CartStatus.loading));
    try {
      final bookId = int.tryParse(event.book.id);
      if (bookId == null) throw Exception('Invalid book ID');
      
      final newAmount = await _cartRepo.addToCart(bookId);
      
      // Update local state after successful API call
      final existingIndex = state.items.indexWhere((i) => i.book.id == event.book.id);
      if (existingIndex >= 0) {
        final updatedItems = List<CartItem>.from(state.items);
        updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
          quantity: newAmount,
        );
        emit(state.copyWith(items: updatedItems, status: CartStatus.success));
      } else {
        emit(state.copyWith(
          items: [...state.items, CartItem(book: event.book, quantity: newAmount)],
          status: CartStatus.success,
        ));
      }
    } catch (e) {
      emit(state.copyWith(status: CartStatus.failure, errorMessage: e.toString().replaceAll('Exception: ', '')));
    }
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    emit(state.copyWith(items: state.items.where((i) => i.book.id != event.bookId).toList()));
  }

  void _onUpdateQuantity(UpdateQuantity event, Emitter<CartState> emit) {
    final updatedItems = state.items.map((item) {
      if (item.book.id == event.bookId) {
        return item.copyWith(quantity: event.quantity > 0 ? event.quantity : 1);
      }
      return item;
    }).toList();
    emit(state.copyWith(items: updatedItems));
  }

  void _onToggleSelectItem(ToggleSelectItem event, Emitter<CartState> emit) {
    final updatedItems = state.items.map((item) {
      if (item.book.id == event.bookId) {
        return item.copyWith(isSelected: !item.isSelected);
      }
      return item;
    }).toList();
    emit(state.copyWith(items: updatedItems));
  }

  void _onToggleSelectAll(ToggleSelectAll event, Emitter<CartState> emit) {
    final updatedItems = state.items.map((item) {
      return item.copyWith(isSelected: event.isSelected);
    }).toList();
    emit(state.copyWith(items: updatedItems));
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(const CartState());
  }
}
