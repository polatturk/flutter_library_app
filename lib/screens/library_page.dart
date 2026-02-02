import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/api_service.dart';
import '../models/book_model.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final ApiService apiService = ApiService();
  
  // Eksik olan değişken tanımlamaları eklendi
  final List<String> categories = ['Tümü', 'Roman', 'Tarih', 'Bilim', 'Yazılım', 'Psikoloji'];
  int selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dijital Kütüphanem'),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20, top: 0),
            child: IconButton(
              onPressed: () => themeProvider.toggleTheme(),
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // --- Kategori Listesi ---
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(categories[index]),
                    selected: selectedCategoryIndex == index,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedCategoryIndex = index;
                      });
                    },
                    checkmarkColor: Colors.indigo,
                    labelStyle: TextStyle(
                      color: selectedCategoryIndex == index
                          ? Colors.indigo
                          : (isDarkMode ? Colors.white70 : Colors.black87),
                      fontWeight: selectedCategoryIndex == index
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Book>>(
              future: apiService.getBooks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Kitap bulunamadı.'));
                }

                final books = snapshot.data!;

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: books.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.menu_book, color: Colors.indigo),
                        title: Text(book.title), 
                        subtitle: Text(book.author),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {
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