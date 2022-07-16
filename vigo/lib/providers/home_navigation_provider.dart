
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vigo/view_models/home_vm.dart';

final homeViewModel =
    ChangeNotifierProvider<HomeViewModel>((ref) => HomeViewModel(ref.read));