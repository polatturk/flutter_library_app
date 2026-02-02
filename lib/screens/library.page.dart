import 'package:flutter/material.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dijital Kütüphanem'), centerTitle: true),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) => Card(
          child: ListTile(
            leading: const Icon(Icons.menu_book_rounded, color: Colors.indigo),
            title: Text('Kitap Adı #$index'),
            subtitle: const Text('Yazar Adı'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          ),
        ),
      ),
    );
  }
}