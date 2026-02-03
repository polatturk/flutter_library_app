import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';
import 'author_detail_page.dart';

class AuthorPage extends StatelessWidget {
  const AuthorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();
    final authors = dataProvider.authors.where((a) => a.id != 0).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Yazarlar'), centerTitle: true),
      body: dataProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: authors.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final author = authors[index];
                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo.shade100,
                      child: Text(
                        author.name[0],
                        style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text("${author.name} ${author.surname}", 
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(author.placeOfBirth),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthorDetailPage(author: author),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}