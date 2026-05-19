part of 'bin_bloc.dart';

enum BinStatus { initial, loading, success, failure }

class BinState extends Equatable {
  final BinStatus status;
  final List<BookListing> books;
  final String? errorMessage;

  const BinState({
    this.status = BinStatus.initial,
    this.books = const [],
    this.errorMessage,
  });

  BinState copyWith({
    BinStatus? status,
    List<BookListing>? books,
    String? errorMessage,
  }) {
    return BinState(
      status: status ?? this.status,
      books: books ?? this.books,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, books, errorMessage];
}
