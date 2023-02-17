import 'package:flutter/material.dart';
import 'package:submission_flutter_intermediate/api/api_service.dart';
import 'package:submission_flutter_intermediate/data/response/common_response.dart';
import 'package:submission_flutter_intermediate/db/auth_repository.dart';

import '../model/user.dart';

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

  Future<bool> login(User user) async {
    isLoadingLogin = true;
    notifyListeners();
    final userState = await authRepository.getUser();
    if (user == userState) {
      await authRepository.login();
    }
    isLoggedIn = await authRepository.isLoggedIn();
    isLoadingLogin = false;
    notifyListeners();
    return isLoggedIn;
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

  Future<bool> saveUser(User user) async {
    isLoadingRegister = true;
    notifyListeners();
    final userState = await authRepository.saveUser(user);
    isLoadingRegister = false;
    notifyListeners();
    return userState;
  }

  Future<void> register(User user) async {
    try {
      message = "";
      commonResponse = null;
      isLoadingRegister = true;
      notifyListeners();

      commonResponse = await apiService.register(user);
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
