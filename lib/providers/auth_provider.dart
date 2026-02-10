import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  bool _isLoading = false;

  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;

  // Giriş Metodu (ApiService ile bağlanacak)
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Burada ApiService.login() çağrılacak. Şimdilik simüle ediyoruz:
      await Future.delayed(const Duration(seconds: 2));
      _token = "fake-jwt-token"; // API'den gelen token buraya atanacak
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Çıkış Metodu
  void logout() {
    _token = null;
    notifyListeners();
  }
}