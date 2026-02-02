class Book {
  final int id;
  final String title;
  final String author;
  final String? description;

  Book({required this.id, required this.title, required this.author, this.description});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'] ?? 'İsimsiz Kitap',
      author: json['author'] ?? 'Bilinmeyen Yazar',
      description: json['description'],
    );
  }
}