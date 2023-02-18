import 'package:flutter/material.dart';
import 'package:submission_flutter_intermediate/api/api_service.dart';
import 'package:submission_flutter_intermediate/data/response/common_response.dart';
import 'package:submission_flutter_intermediate/db/auth_repository.dart';

import '../data/response/login_response.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final ApiService apiService;

  AuthProvider(this.authRepository, this.apiService);

  bool isLoadingLogin = false;
  bool isLoadingLogout = false;
  bool isLoadingRegister = false;
  bool isLoggedIn = false;

  String message = "";
  CommonResponse? commonResponse;
  LoginResponse? loginResponse;

  // Future<bool> login(User user) async {
  //   isLoadingLogin = true;
  //   notifyListeners();
  //   final userState = await authRepository.getUser();
  //   if (user == userState) {
  //     await authRepository.login();
  //   }
  //   isLoggedIn = await authRepository.isLoggedIn();
  //   isLoadingLogin = false;
  //   notifyListeners();
  //   return isLoggedIn;
  // }

  Future<void> login(String email, String password) async {
    try {
      isLoadingLogin = true;
      loginResponse = null;
      notifyListeners();

      loginResponse = await apiService.login(email, password);
      message = loginResponse?.message ?? 'success';
      await authRepository.saveUser(loginResponse!.loginResult);
      isLoadingLogin = false;
      notifyListeners();
    } catch (e) {
      isLoadingLogin = false;
      message = e.toString();
      notifyListeners();
    }
  }

  Future<bool> logout() async {
    isLoadingLogout = true;
    notifyListeners();
    final logout = await authRepository.logout();
    if (logout) {
      await authRepository.deleteUser();
    }
    isLoggedIn = await authRepository.isLoggedIn();
    isLoadingLogout = false;
    notifyListeners();
    return !isLoggedIn;
  }

  Future<void> register(String name, String email, String password) async {
    try {
      message = "";
      commonResponse = null;
      isLoadingRegister = true;
      notifyListeners();

      commonResponse = await apiService.register(name, email, password);
      message = commonResponse?.message ?? 'success';
      isLoadingRegister = false;
      notifyListeners();
    } catch (e) {
      isLoadingRegister = false;
      message = e.toString();
      notifyListeners();
    }
  }
}
