import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vigo/providers/auth_provider.dart';
import 'package:vigo/view_models/base_vm.dart';

class HomeViewModel extends BaseViewModel {
  int selectedIndex = 0;
  HomeViewModel(Reader read) : super(read) {}

  void changeIndex(int index) async {
    selectedIndex = index;
    await read(authViewModel).getAllUserAdmin();
    notifyListeners();
  }
}
