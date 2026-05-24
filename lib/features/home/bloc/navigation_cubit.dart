import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationCubit extends Cubit<int> {
  NavigationCubit(int initialIndex) : super(initialIndex);

  void setTab(int index) => emit(index);
}
