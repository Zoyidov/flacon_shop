import 'package:flacon_shop/data/cubit/tab_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabCubit extends Cubit<TabState> {
  TabCubit() : super(InitialTabState());

  void changeTab(int tabIndex) {
    TabState newState;
    switch (tabIndex) {
      case 0:
        newState = InitialTabState();
        break;
      case 1:
        newState = FavouriteTabState();
        break;
      case 2:
        newState = NotificationTabState();
        break;
      case 3:
        newState = ProfileTabState();
        break;
      default:
        newState = InitialTabState();
    }
    emit(newState);
  }
}