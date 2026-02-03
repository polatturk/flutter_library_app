class User {
  final int id;
  final String name;
  final String surname;
  final String username;
  final String email;
  final DateTime recordDate;
  
  User({required this.id, required this.name ,  required this.surname, required this.username, required this.email, required this.recordDate});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      recordDate: json['recordDate'] != null ? DateTime.parse(json['recordDate']) : DateTime.now(),);
  }
}