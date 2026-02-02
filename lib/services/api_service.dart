import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';

class ApiService {
  static const String baseUrl = 'https://booksapi.polatturkk.com.tr/api';

  Future<List<Book>> getBooks() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/Book/ListAll'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      
      // EĞER API veriyi bir 'data' veya 'items' key'i içinde gönderiyorsa:
      // Swagger'dan bakarak bu key ismini (data/items/list) doğrula.
      final List<dynamic> jsonList = responseData['data'] ?? []; 

      return jsonList.map((data) => Book.fromJson(data)).toList();
    } else {
      throw Exception('Sunucu Hatası: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Bağlantı sağlanamadı: $e');
  }
}
}