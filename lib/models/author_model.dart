class Author {
  final int id;
  final String name;
  final String surname;
  final DateTime recordDate;
  final String placeOfBirth;
  final int yearOfBirth;
  

  Author({required this.id, required this.name ,  required this.surname, required this.recordDate, required this.placeOfBirth, required this.yearOfBirth});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      placeOfBirth: json['placeOfBirth'] ?? '',
      yearOfBirth: json['yearOfBirth'] ?? 0,
      recordDate: json['recordDate'] != null 
          ? DateTime.parse(json['recordDate']) 
          : DateTime.now(),
    );
  }
}