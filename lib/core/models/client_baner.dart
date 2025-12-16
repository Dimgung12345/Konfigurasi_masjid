class ClientBanner {
  final int id;
  final String clientId;
  final String path;
  final DateTime createdAt;
  final String? url; // ✅ tambahan field

  ClientBanner({
    required this.id,
    required this.clientId,
    required this.path,
    required this.createdAt,
    this.url,
  });

  factory ClientBanner.fromJson(Map<String, dynamic> json) {
    return ClientBanner(
      id: json['id'],
      clientId: json['client_id'],
      path: json['path'],
      createdAt: DateTime.parse(json['created_at']),
      url: json['url'], // ✅ parsing field baru
    );
  }
}