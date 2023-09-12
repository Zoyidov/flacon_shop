import 'package:flacon_shop/data/network/providers/api_provider.dart';
import 'package:flacon_shop/data/repository/category_repo.dart';
import 'package:flacon_shop/data/repository/product_repository.dart';
import 'package:flacon_shop/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/cubit/tab_cubit.dart';
import '../../data/cubit/tab_state.dart';
import '../screens/cart_screen.dart';
import '../screens/favourite_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';

class TabBox extends StatelessWidget {
  const TabBox({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabCubit, TabState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: _getScreenForTabState(state),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            elevation: 0,
            currentIndex: _currentIndexForTabState(state),
            showSelectedLabels: true,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900),
            selectedItemColor: Colors.black,
            onTap: (index) {
              context.read<TabCubit>().changeTab(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  AppImages.home,
                  height: 25,
                ),
                label: '•',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(AppImages.favourite),
                label: '•',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(AppImages.cart),
                label: '•',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(AppImages.profile),
                label: '•',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getScreenForTabState(TabState state) {
    switch (state.runtimeType) {
      case InitialTabState:
        return HomeScreen(
          productRepo: ProductRepo(apiProvider: ApiProvider()),
          categoryRepo: CategoryRepo(apiProvider: ApiProvider()),
        );
      case FavouriteTabState:
        return const FavouriteScreen();
      case NotificationTabState:
        return const CartScreen();
      case ProfileTabState:
        return const ProfileScreen();
      default:
        return const Center(child: Text('Unknown Tab'));
    }
  }

  int _currentIndexForTabState(TabState state) {
    if (state is InitialTabState) {
      return 0;
    } else if (state is FavouriteTabState) {
      return 1;
    } else if (state is NotificationTabState) {
      return 2;
    } else if (state is ProfileTabState) {
      return 3;
    } else {
      return -1;
    }
  }
}
