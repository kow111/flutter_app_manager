class UserDTO {
  String username;
  bool isVerified;
  bool isAdmin;
  bool isActive;

  UserDTO({
    required this.username,
    required this.isVerified,
    required this.isAdmin,
    required this.isActive,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      username: json['username'],
      isVerified: json['is_verified'],
      isAdmin: json['is_admin'],
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'is_verified': isVerified,
      'is_admin': isAdmin,
      'is_active': isActive,
    };
  }
}
