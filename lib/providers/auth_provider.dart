import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  String? _token;
  String? _name;
  String? _surname;
  String? _username;
  String? _email;
  bool _isLoading = false;

  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;
  String get fullName => "${_name ?? ''} ${_surname ?? ''}".trim();
  String get userEmail => _email ?? "";
  String get userNick => _username ?? "";

  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _apiService.login(email, password);

      if (result['isSuccess'] == true) {
        _token = result['data']; // JWT Token burada
        
        var userData = result['user']; 
        if (userData != null) {
          _name = userData['name'];         
          _surname = userData['surname'];   
          _username = userData['username']; 
          _email = userData['email'];     
        }

        _isLoading = false;
        notifyListeners();
        return null; 
      } else {
        _isLoading = false;
        notifyListeners();
        return result['message'] ?? "Giriş başarısız.";
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return "Bağlantı hatası: $e";
    }
  }

  // Kayıt Metodu
  Future<String?> create({
    required String name,
    required String surname,
    required String username,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _apiService.create(name, surname, username, email, password);

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

  // Çıkış Metodu
  void logout() {
    _token = null;
    _name = null;
    _surname = null;
    _username = null;
    _email = null;
    notifyListeners();
  }
}