
class AppUser {
  final String uid;
  final String name;
  final String email;
  final String role;
  final DateTime? createdAt;

  AppUser({required this.uid, required this.name, required this.email,
      required this.role, this.createdAt});

  Map<String, dynamic> toMap() => {
    'name': name, 'email': email, 'role': role,
    'createdAt': createdAt,
  };

  factory AppUser.fromMap(String uid, Map<String, dynamic> m) => AppUser(
    uid: uid, name: m['name'] ?? '', email: m['email'] ?? '',
    role: m['role'] ?? 'student',
    createdAt: m['createdAt']?.toDate(),
  );
}
