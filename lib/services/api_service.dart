import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:library_app/models/user_model.dart';
import '../models/book_model.dart';
import '../models/category_model.dart';
import '../models/author_model.dart';
import '../models/user_model.dart';


class ApiService {
  static const String baseUrl = 'https://booksapi.polatturkk.com.tr/api';

  Future<Map<String, dynamic>> processResponse(http.Response response) async {
    final contentType = response.headers['content-type'];

    if (contentType != null && contentType.contains('application/json')) {
      return json.decode(response.body);
    } else {
      return {
        'isSuccess': false,
        'message': response.body.isEmpty ? "Bir hata oluştu (Kod: ${response.statusCode})" : response.body
      };
    }
  }
  
  Future<List<Book>> getBooks() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/Book/ListAll'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> jsonList = responseData['data'] ?? []; 
        return jsonList.map((data) => Book.fromJson(data)).toList();
      } else {
        throw Exception('Sunucu Hatası: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Bağlantı sağlanamadı: $e');
    }
  }

  Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/Category/ListAll'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> jsonList = responseData['data'] ?? [];

        List<Category> categories = jsonList.map((data) => Category.fromJson(data)).toList();

        return [
          Category(id: 0, name: 'Tümü', description: 'Tüm kitapları listeler'),
          ...categories
        ];
      } else {
        throw Exception('Kategoriler alınamadı: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Bağlantı sağlanamadı: $e');
    }
  }

  Future<List<Author>> getAuthors() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/Author/ListAll'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> jsonList = responseData['data'] ?? [];
        
        List<Author> authors = jsonList.map((data) => Author.fromJson(data)).toList();

        return [
          Author(id: 0, name: 'Tümü', surname: '', placeOfBirth: '', yearOfBirth: 0, recordDate: DateTime.now()),
          ...authors
        ];
      } else {
        throw Exception('Yazarlar yüklenemedi');
      }
    } catch (e) {
      throw Exception('Hata: $e');
    }
  }

  Future<List<User>> getUsers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/User/ListAll'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> jsonList = responseData['data'] ?? [];
        
        List<User> users = jsonList.map((data) => User.fromJson(data)).toList();

        return [ User(id: 0, name: '', surname: '', username: '' , email: '', recordDate: DateTime.now()), ...users];
      } else {
        throw Exception('Kullanıcılar yüklenemedi');
      }
    } catch (e) {
      throw Exception('Hata: $e');
    }
  }


  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/User/Login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': "", // UI'da istemiyoruz ama API beklediği için boş gönderiyoruz
          'email': email,
          'password': password,
        }),
      );

      return await processResponse(response);
    } catch (e) {
    return {'isSuccess': false, 'message': 'Bağlantı hatası: Sunucuya ulaşılamıyor.'};  
    }
  }

  Future<Map<String, dynamic>> register(
    String name, String surname, String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/User/Create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
        'name': name,
        'surname': surname,
        'username': username,
        'email': email,
        'password': password,
        }),
      );

      return await processResponse(response);
    } catch (e) {
      return {'isSuccess': false, 'message': 'Bağlantı hatası: Kayıt yapılamadı.'};
    }
  }
}