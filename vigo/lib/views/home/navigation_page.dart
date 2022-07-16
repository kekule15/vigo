
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/admin/directory_v1.dart';
import 'package:vigo/providers/auth_provider.dart';
import 'package:vigo/providers/home_navigation_provider.dart';
import 'package:vigo/styles/custom_colors.dart';
import 'package:vigo/views/home/home.dart';
import 'package:vigo/views/home/home_drawer.dart';
import 'package:vigo/views/home/users/list_user.dart';
import 'package:vigo/views/home/users/user_profile.dart';

class HomeNavigation extends ConsumerStatefulWidget {
  const HomeNavigation({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeNavigation();
}

class _HomeNavigation extends ConsumerState<HomeNavigation> {
  @override
  Widget build(BuildContext context) {
    final _viewModel = ref.watch(homeViewModel);
      var authservice = ref.watch(authViewModel);
    // final user = _viewModel.user.data;
    Future<bool> _onBackPressed() {
      return Future.delayed(const Duration(seconds: 2));
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
        body: _pages.elementAt(ref.watch(homeViewModel).selectedIndex),
        drawer: const MyDrawerPage(),
        bottomNavigationBar: Theme(
          data: Theme.of(context),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(
              color: CustomColors.background,
            ),
            unselectedLabelStyle: const TextStyle(color: CustomColors.grey),
            unselectedItemColor: CustomColors.grey,
            backgroundColor: CustomColors.blackColor,
            showSelectedLabels: true,
            selectedItemColor: CustomColors.background,
            currentIndex: ref.watch(homeViewModel).selectedIndex,
            onTap: _viewModel.changeIndex,
            items: [
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: ref.watch(homeViewModel).selectedIndex == 0
                    ? const Icon(Icons.person)
                    : const Icon(Icons.person),
                label: "User",
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: ref.watch(homeViewModel).selectedIndex == 3
                    ? const Icon(Icons.chat)
                    : const Icon(Icons.chat),
                label: "Chat",
              ),
             
            ],
          ),
        ),
      ),
    );
  }

  static const List<Widget> _pages = <Widget>[
    UserProfile(),
    ListUsers(),
    
  ];
}
