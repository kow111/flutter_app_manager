class User {
  String id;
  String username;
  String email;
  String gender;
  String image;
  bool isVerified;
  bool isAdmin;
  bool isActive;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.gender,
    required this.image,
    required this.isVerified,
    required this.isAdmin,
    required this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'] ?? 'Chưa đặt tên',
      email: json['email'],
      gender: json['gender'] ?? 'OTHER',
      image: json['image'] ?? '',
      isVerified: json['is_verified'] ?? false,
      isAdmin: json['is_admin'] ?? false,
      isActive: json['is_active'] ?? false,
    );
  }
}
