class Child {
  final int id;
  final String name;
  final DateTime birthDate;
  final int age;
  final int ageMonths;
  final String? avatarUrl;

  Child({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.age,
    required this.ageMonths,
    this.avatarUrl,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'],
      name: json['name'],
      birthDate: DateTime.parse(json['birth_date']),
      age: json['age'],
      ageMonths: json['age_months'],
      avatarUrl: json['avatar_url'],
    );
  }

  String get ageDisplay {
    if (ageMonths < 12) {
      return '$ageMonths months';
    } else if (ageMonths < 24) {
      return '1 year';
    } else {
      return '$age years';
    }
  }
}