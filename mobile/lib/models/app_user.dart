
class AppUser {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final String? companyName;

  const AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.companyName,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      fullName: json['fullName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? 'candidate',
      companyName: json['companyName']?.toString(),
    );
  }

  String get firstName {
    final name = fullName.trim();

    if (name.isEmpty) return '';

    return name.split(' ').first;
  }
}
