class Book {
  final int id;
  final String title;
  final String author;
  final String? description;
  final int categoryId;
  final int authorId; 

  Book({required this.id, required this.title, required this.author, this.description , required this.categoryId, required this.authorId});

  factory Book.fromJson(Map<String, dynamic> json) {
    final authorData = json['author'];
    
    String authorFullName = 'bilinmeyen yazar';
    
    if (authorData != null) {
      authorFullName = "${authorData['name']} ${authorData['surname']}";
    }

    return Book(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'İsimsiz Kitap',
      author: authorFullName,
      description: json['description'],
      categoryId: json['categoryId'] ?? 0,
      authorId: json['authorId'] ?? 0,
    );
  }
}