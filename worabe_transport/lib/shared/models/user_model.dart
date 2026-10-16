class UserModel {
  const UserModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.role,
    this.preferredLanguage = 'en',
  });

  final String id;
  final String fullName;
  final String phone;
  final String role;
  final String preferredLanguage;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: (json['id'] ?? json['_id']).toString(),
        fullName: json['fullName'] as String,
        phone: json['phone'] as String,
        role: json['role'] as String,
        preferredLanguage: json['preferredLanguage'] as String? ?? 'en',
      );

  bool get isDriver => role == 'driver';
  bool get isPassenger => role == 'passenger';
  bool get isAdmin => role == 'admin';
}
