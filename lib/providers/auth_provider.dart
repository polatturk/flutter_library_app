import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  String? _token;
  bool _isLoading = false;

  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;

  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // API'ye isteği gönderiyoruz
      final result = await _apiService.login(email, password);

      if (result['isSuccess'] == true) {
        _token = result['data']; // API'den gelen JWT Token
        _isLoading = false;
        notifyListeners();
        return null; // Başarılıysa hata mesajı boş döner
      } else {
        _isLoading = false;
        notifyListeners();
        return result['message'] ?? "Giriş başarısız."; // Backend mesajını göster
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return "Bağlantı hatası: Sunucuya ulaşılamıyor.";
    }
  }

  Future<String?> register({
    required String name,
    required String surname,
    required String username,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _apiService.register(name, surname, username, email, password);

      if (result['isSuccess'] == true) {
        _isLoading = false;
        notifyListeners();
        return null;
      } else {
        _isLoading = false;
        notifyListeners();
        return result['message'] ?? "Kayıt işlemi başarısız.";
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return "Bağlantı hatası: Kayıt yapılamadı.";
    }
  }

  void logout() {
    _token = null;
    notifyListeners();
  }
}