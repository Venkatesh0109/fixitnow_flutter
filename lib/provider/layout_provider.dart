import 'package:auscurator/model/login_model.dart';
import 'package:flutter/material.dart';

class LayoutProvider extends ChangeNotifier {
  int _pageIndex = 0;
  int get pageIndex => _pageIndex;
  set pageIndex(int val) {
    _pageIndex = val;
    notifyListeners();
  }

  LoginModel _loginData = LoginModel();
  LoginModel get loginData => _loginData;
  set loginData(LoginModel val) {
    _loginData = val;
    notifyListeners();
  }
}
