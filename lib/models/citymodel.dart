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

  @override
  String toString() => "$city, $state";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is City &&
          runtimeType == other.runtimeType &&
          city == other.city &&
          state == other.state;

  @override
  int get hashCode => city.hashCode ^ state.hashCode;
}


