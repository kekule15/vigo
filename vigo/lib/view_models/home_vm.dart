

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vigo/view_models/base_vm.dart';

class HomeViewModel extends BaseViewModel {
  int selectedIndex = 0;
  HomeViewModel(Reader read) : super(read) {
   
  }


  void changeIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
