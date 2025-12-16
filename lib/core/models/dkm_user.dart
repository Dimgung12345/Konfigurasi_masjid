class DkmUser {
  final String id;
  final String clientId;
  final String username;
  final String role;
  final DateTime createdAt;

  DkmUser({
    required this.id,
    required this.clientId,
    required this.username,
    required this.role,
    required this.createdAt,
  });

  factory DkmUser.fromJson(Map<String, dynamic> json) {
    return DkmUser(
      id: json["id"],
      clientId: json["client_id"],
      username: json["username"],
      role: json["role"],
      createdAt: DateTime.parse(json["created_at"]),
    );
  }
}