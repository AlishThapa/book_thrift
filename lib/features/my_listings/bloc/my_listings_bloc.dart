import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'my_listings_event.dart';
part 'my_listings_state.dart';

class MylistingsBloc extends Bloc<MyListingsEvent, MyListingsState> { MylistingsBloc() : super(const MyListingsState()); }
