import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../models/category_model.dart';
import '../models/author_model.dart';
import '../services/api_service.dart';

class DataProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Book> books = [];
  List<Category> categories = [];
  List<Author> authors = [];
  bool isLoading = false;
  String? error;

  Future<void> loadLibraryData() async {
    if (books.isNotEmpty && categories.isNotEmpty) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _apiService.getBooks(),
        _apiService.getCategories(),
        _apiService.getAuthors(),
      ]);

      books = results[0] as List<Book>;
      categories = results[1] as List<Category>;
      authors = results[2] as List<Author>;
    } catch (e) {
      error = "Veriler yüklenirken bir sorun oluştu. (503)";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}