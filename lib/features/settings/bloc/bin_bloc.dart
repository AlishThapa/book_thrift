import 'package:bloc/bloc.dart';
import 'package:book_thrift/features/listing/models/book_listing.dart';
import 'package:book_thrift/features/settings/repo/bin_repository.dart';
import 'package:equatable/equatable.dart';

part 'bin_event.dart';
part 'bin_state.dart';

class BinBloc extends Bloc<BinEvent, BinState> {
  final BinRepository _binRepository;

  BinBloc(this._binRepository) : super(const BinState()) {
    on<FetchBin>(_onFetchBin);
    on<RecoverBook>(_onRecoverBook);
    on<PermanentlyDeleteBook>(_onPermanentlyDeleteBook);
    on<RecoverAllBooks>(_onRecoverAllBooks);
    on<DeleteAllBooks>(_onDeleteAllBooks);
  }

  Future<void> _onFetchBin(FetchBin event, Emitter<BinState> emit) async {
    emit(state.copyWith(status: BinStatus.loading));
    try {
      final books = await _binRepository.getBin();
      emit(state.copyWith(status: BinStatus.success, books: books));
    } catch (e) {
      emit(state.copyWith(status: BinStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onRecoverBook(RecoverBook event, Emitter<BinState> emit) async {
    try {
      await _binRepository.recoverBook(event.bookId);
      add(FetchBin());
    } catch (e) {
      emit(state.copyWith(status: BinStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onPermanentlyDeleteBook(PermanentlyDeleteBook event, Emitter<BinState> emit) async {
    try {
      await _binRepository.permanentlyDeleteBook(event.bookId);
      add(FetchBin());
    } catch (e) {
      emit(state.copyWith(status: BinStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onRecoverAllBooks(RecoverAllBooks event, Emitter<BinState> emit) async {
    try {
      await _binRepository.recoverAllBooks();
      add(FetchBin());
    } catch (e) {
      emit(state.copyWith(status: BinStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onDeleteAllBooks(DeleteAllBooks event, Emitter<BinState> emit) async {
    try {
      await _binRepository.deleteAllBooks();
      add(FetchBin());
    } catch (e) {
      emit(state.copyWith(status: BinStatus.failure, errorMessage: e.toString()));
    }
  }
}
