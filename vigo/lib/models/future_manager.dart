import 'package:flutter/material.dart';

class FutureManager<T> extends ChangeNotifier {
  bool loading = true;
  String error = "";
  T? data;

  load() {
    loading = true;
    error = "";
    data = null;
    notifyListeners();
  }

  onSuccess(T result) {
    data = result;
    error = "";
    loading = false;
    notifyListeners();
  }

  onError(String errorMesssage) {
    data = null;
    error = errorMesssage;
    loading = false;
    notifyListeners();
  }
}
