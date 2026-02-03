import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/api_service.dart';
import '../models/book_model.dart';
import '../models/category_model.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final ApiService apiService = ApiService();
  
  // Late hatasını önlemek için Future'ları burada tanımlıyoruz
  late Future<List<Category>> _categoriesFuture;
  late Future<List<Book>> _booksFuture;

  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    // Verileri initState içinde sadece BİR KEZ çekiyoruz. 
    // Bu sayede 503 hatasının (aşırı istek) önüne geçiyoruz.
    _categoriesFuture = apiService.getCategories();
    _booksFuture = apiService.getBooks();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dijital Kütüphanem'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => themeProvider.toggleTheme(),
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          // --- Kategori Listesi Bölümü ---
          SizedBox(
            height: 70,
            child: FutureBuilder<List<Category>>(
              future: _categoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: LinearProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Kategoriler alınamadı"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const SizedBox();
                }

                final categories = snapshot.data!;
                // Varsayılan olarak ilk kategoriyi (Tümü) seçiyoruz
                _selectedCategory ??= categories.first;

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final bool isSelected = _selectedCategory?.id == category.id;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category.name),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setState(() {
                            // Sadece seçili kategoriyi güncelliyoruz, 
                            // API'ye tekrar istek ATMIYORUZ.
                            _selectedCategory = category;
                          });
                        },
                        checkmarkColor: Colors.indigo,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.indigo
                              : (isDarkMode ? Colors.white70 : Colors.black87),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // --- Kitap Listesi Bölümü ---
          Expanded(
            child: FutureBuilder<List<Book>>(
              future: _booksFuture, // Hafızadaki kitap listesini kullanıyoruz
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Kitap bulunamadı.'));
                }

                // Filtreleme Mantığı: Veri zaten snapshot'ta var, 
                // biz sadece arayüzde hangilerini göstereceğimizi seçiyoruz.
                final allBooks = snapshot.data!;
                final filteredBooks = (_selectedCategory == null || _selectedCategory!.id == 0)
                    ? allBooks
                    : allBooks.where((b) => b.categoryId == _selectedCategory!.id).toList();

                if (filteredBooks.isEmpty) {
                  return const Center(child: Text('Bu kategoride henüz kitap yok.'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredBooks.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final book = filteredBooks[index];
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.menu_book, color: Colors.indigo),
                        title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)), 
                        subtitle: Text(book.author),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {
                          // Kitap detay sayfasına gitme kodu buraya gelecek
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}