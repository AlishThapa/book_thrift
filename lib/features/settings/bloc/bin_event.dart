part of 'bin_bloc.dart';

abstract class BinEvent extends Equatable {
  const BinEvent();

  @override
  List<Object> get props => [];
}

class FetchBin extends BinEvent {}

class RecoverBook extends BinEvent {
  final String bookId;
  const RecoverBook(this.bookId);

  @override
  List<Object> get props => [bookId];
}

class RecoverAllBooks extends BinEvent {}

class DeleteAllBooks extends BinEvent {}

class PermanentlyDeleteBook extends BinEvent {
  final String bookId;
  const PermanentlyDeleteBook(this.bookId);

  @override
  List<Object> get props => [bookId];
}

