import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';
import '../models/category_model.dart';
import '../models/author_model.dart';


class ApiService {
  static const String baseUrl = 'https://booksapi.polatturkk.com.tr/api';

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
}