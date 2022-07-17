import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vigo/services/authentication_services.dart';
import 'package:vigo/view_models/authentication_vm.dart';

final authViewModel = ChangeNotifierProvider<AuthViewModel>(
    (ref) => AuthViewModel(ref.read));

final authServiceProvider = Provider<AuthServiceImplementation>(
    (ref) => AuthServiceImplementation(ref.read));
