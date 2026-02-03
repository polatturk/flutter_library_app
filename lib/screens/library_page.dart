import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/data_provider.dart'; 
import '../models/book_model.dart';
import '../models/category_model.dart';
import '../models/author_model.dart';
import 'book_detail_page.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> with AutomaticKeepAliveClientMixin {
  Category? _selectedCategory;

  @override
  bool get wantKeepAlive => true; 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DataProvider>().loadLibraryData();
    });
  }

  String _getAuthorNameById(List<Author> authors, int authorId) {
    try {
      final author = authors.firstWhere((a) => a.id == authorId);
      return "${author.name} ${author.surname}";
    } catch (e) {
      return "Bilinmeyen Yazar";
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // KeepAlive için gerekli
    
    final themeProvider = Provider.of<ThemeProvider>(context);
    final dataProvider = context.watch<DataProvider>(); // Verileri buradan izliyoruz
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
      body: _buildBody(dataProvider, isDarkMode),
    );
  }

  Widget _buildBody(DataProvider dataProvider, bool isDarkMode) {
    if (dataProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (dataProvider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(dataProvider.error!),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => dataProvider.loadLibraryData(),
              child: const Text("Tekrar Dene"),
            ),
          ],
        ),
      );
    }

    final allBooks = dataProvider.books;
    final allAuthors = dataProvider.authors;
    final allCategories = dataProvider.categories;

    final filteredBooks = allBooks.where((book) {
      return (_selectedCategory == null || _selectedCategory!.id == 0) 
          ? true 
          : book.categoryId == _selectedCategory!.id;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Kategoriler"),
        _buildCategoryList(allCategories),
        const Divider(height: 1),
        Expanded(
          child: filteredBooks.isEmpty
              ? const Center(child: Text('Bu kategoride henüz kitap yok.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredBooks.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final book = filteredBooks[index];
                    final authorName = _getAuthorNameById(allAuthors, book.authorId);
                    return _buildBookCard(book, authorName);
                  },
                ),
        ),
      ],
    );
  }


  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 10, bottom: 4),
      child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }

  Widget _buildCategoryList(List<Category> categories) {
    if (categories.isEmpty) return const SizedBox();
    _selectedCategory ??= categories.first;

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory?.id == category.id;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(category.name),
              selected: isSelected,
              onSelected: (val) {
                if (val) setState(() => _selectedCategory = category);
              },
            ),
          );
        },
      ),
    );
  }

    Widget _buildBookCard(Book book, String authorName) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.menu_book, color: Colors.indigo),
        title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(authorName),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
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
  }
}