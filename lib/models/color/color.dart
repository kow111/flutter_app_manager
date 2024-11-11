class Color {
  final String id;
  final String name;

  Color({
    required this.id,
    required this.name,
  });

  factory Color.fromJson(Map<String, dynamic> json) {
    return Color(
      id: json['_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}
