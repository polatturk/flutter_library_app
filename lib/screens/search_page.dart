import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';
import '../models/book_model.dart';
import '../models/author_model.dart';
import 'book_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchQuery = ""; 

  String _getAuthorName(List<Author> authors, int authorId) {
    try {
      final author = authors.firstWhere((a) => a.id == authorId);
      return "${author.name} ${author.surname}";
    } catch (e) {
      return "Bilinmeyen Yazar";
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();
    final allBooks = dataProvider.books;
    final allAuthors = dataProvider.authors;

    final filteredBooks = allBooks.where((book) {
      final authorName = _getAuthorName(allAuthors, book.authorId).toLowerCase();
      final bookTitle = book.title.toLowerCase();
      final query = _searchQuery.toLowerCase();

      return bookTitle.contains(query) || authorName.contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Kitap Ara'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBar(
              leading: const Icon(Icons.search),
              hintText: "Kitap veya yazar ara...",
              onChanged: (value) {
                setState(() {
                  _searchQuery = value; 
                });
              },
              padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16)),
            ),
          ),

          // Sonuç Listesi
          Expanded(
            child: _searchQuery.isEmpty
                ? _buildEmptyState(Icons.manage_search, "Aramaya başlayın...")
                : filteredBooks.isEmpty
                    ? _buildEmptyState(Icons.search_off, "Sonuç bulunamadı.")
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredBooks.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final book = filteredBooks[index];
                          final authorName = _getAuthorName(allAuthors, book.authorId);

                          return Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.shade200),
                            ),
                            child: ListTile(
                              title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(authorName),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookDetailPage(
                                      book: book,
                                      authorName: authorName,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(message, style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
        ],
      ),
    );
  }
}