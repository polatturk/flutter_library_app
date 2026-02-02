import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kitap Ara')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SearchBar(
          leading: const Icon(Icons.search),
          hintText: "Kitap veya yazar ara...",
          padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16)),
        ),
      ),
    );
  }
}