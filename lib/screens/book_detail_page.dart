import 'package:flutter/material.dart';
import '../models/book_model.dart';

class BookDetailPage extends StatelessWidget {
  final Book book;
  final String authorName;

  const BookDetailPage({
    super.key,
    required this.book,
    required this.authorName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitap Detayı'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Üst Kısım: İkon ve Başlık
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  size: 80,
                  color: Colors.indigo,
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              book.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
            ),
            const SizedBox(height: 8),

            Text(
              authorName,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const Divider(height: 40),

            // Row(
            //   children: [
            //     _buildInfoChip(Icons.calendar_today, 
            //       "${book.recordDate.day}/${book.recordDate.month}/${book.recordDate.year}"),
            //     const SizedBox(width: 12),
            //     _buildInfoChip(Icons.category_outlined, "ID: ${book.categoryId}"),
            //   ],
            // ),
            const SizedBox(height: 24),

            const Text(
              "Kitap Açıklaması",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              book.description ?? "Bu kitap için henüz bir açıklama girilmemiş.",
              style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.indigo),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}