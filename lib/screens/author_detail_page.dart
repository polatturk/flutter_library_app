import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/author_model.dart';
import '../providers/data_provider.dart';
import 'book_detail_page.dart';

class AuthorDetailPage extends StatelessWidget {
  final Author author;

  const AuthorDetailPage({super.key, required this.author});

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();
    
    final authorBooks = dataProvider.books.where((b) => b.authorId == author.id).toList();

    return Scaffold(
      appBar: AppBar(title: Text("${author.name} ${author.surname}")),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(Icons.history_edu, size: 60, color: Colors.indigo),
                const SizedBox(height: 16),
                Text("${author.name} ${author.surname}", 
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text("Doğum: ${author.yearOfBirth} - ${author.placeOfBirth}"),
                const SizedBox(height: 8),
                Text("${authorBooks.length} Kitap Bulundu", 
                    style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: authorBooks.isEmpty
                ? const Center(child: Text("Yazara ait kitap bulunamadı."))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: authorBooks.length,
                    itemBuilder: (context, index) {
                      final book = authorBooks[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.book, color: Colors.indigo),
                          title: Text(book.title),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookDetailPage(
                                  book: book,
                                  authorName: "${author.name} ${author.surname}",
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
}