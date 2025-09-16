class City {
  final String id;
  final String city;
  final String state;

  City({
    required this.id,
    required this.city,
    required this.state,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      city: json['city'] ?? '',
      state: json['state'] ?? '',
    );
  }
}
